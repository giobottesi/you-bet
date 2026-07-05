# Dia 07 — Três cards entregues, próxima leva já escopada

**Data**: 2026-07-02
**Fase do sprint**: Sessões Anônimas (BE 14) → Segurança (BE 15) → Harden (BE 19)
**Planejado**: Avançar do motor de simulação para sessões, rate limiting e testes de borda

## TL;DR

- **Três cards construídos, revisados e mergeados na `main` no mesmo dia**: BE 14 sessões anônimas (#30), BE 15 rate limiting com Rack::Attack (#31), BE 19 testes de borda (#32). Um dia atravessando três seções do sprint.
- **BE 14** dá a cada visitante um cookie UUID assinado e permanente e liga os registros de `Simulation` a ele — sem conta, sem PII, o resultado continua sendo de alguém.
- **BE 15** envolve o app no `Rack::Attack`: throttles ajustáveis por ENV nas simulações e no tráfego geral, 429 ao estourar. O endpoint público deixa de ser uma torneira de computação grátis.
- **BE 19** martela o núcleo Monte Carlo em 17 exemplos — valores zero/negativo/extremo, house edge fixado em 0 e em 1.0, tipo de aposta desconhecido, todos os tipos conhecidos — garantindo degradação graciosa.
- **Gio passou o dia dirigindo, não digitando**: travou o escopo dos *próximos* cinco cards (BE 16–19 + toda a trilha FE) num único registro de decisão, e mergeou os três PRs ele mesmo na ordem de dependência. Tanque do backend vazio; amanhã é rascunho e desenho.

---

## O que foi feito

### BE 14 — visitante ganha identidade sem conta

O concern `VisitorIdentifiable` entra no `ApplicationController`: um cookie UUID assinado e permanente criado no primeiro acesso e lido em toda request seguinte. O novo model `Simulation` carrega um `visitor_id` para rastrear uma rodada até a sessão anônima que a gerou — a base sobre a qual permalinks e cards de compartilhamento vão se apoiar. Oito arquivos, diff enxuto: concern, model, migration e specs provando que o UUID sobrevive entre requests e que os registros ligam corretamente. Sem login, sem email, sem tracking — só identidade suficiente para dizer "esse resultado é seu".

### BE 15 — o endpoint deixa de ser torneira grátis

Initializer do `Rack::Attack` com duas famílias de throttle: uma apertada no endpoint de simulação (o caminho caro) e um limite geral mais frouxo, ambos por ENV para staging e prod ajustarem sozinhos sem redeploy. Estourou o limite, toma 429. Os request specs empurram além do threshold e afirmam que o throttle dispara. `.env.example`, `docker-compose` e os docs `ARCHITECTURE`/`TECH_DEBT` foram no mesmo PR, para o botão ficar documentado onde a próxima pessoa procura.

### BE 19 — quebrar de propósito

Cobertura de borda para o `MonteCarloSimulator`, um spec focado, +98 linhas, 17 exemplos. Os inputs cruéis: valor semanal zero, negativo, absurdamente grande, house edge fixado em 0, em 1.0 (a casa sempre fica com a aposta), tipo de aposta desconhecido, e uma passagem por todos os tipos conhecidos. Um bloco `profit sensitivity to house edge` afirma que a perda escala na direção certa conforme a margem sobe. Não é comportamento novo — é um contrato de que o simulador engole lixo *graciosamente* em vez de estourar ou devolver percentis sem sentido. A seção Harden começando cedo, antes do FE expor esses caminhos a usuários reais.

### Merge na ordem de dependência

Os três caíram na `main` no mesmo dia — #30, depois #31, depois #32, um de cada vez. O sequenciamento não foi cosmético: #30 e #31 tocam `ARCHITECTURE.md` e `SPRINT.md`, então merge paralelo teria atropelado os docs compartilhados. Merge serial mantém os diffs do roadmap limpos e libera o PR de docs para partir de uma `main` já estável.

---

## Decisões & mudanças

O grosso do *pensar* de hoje virou um registro de decisão escopando os próximos cinco cards, para não re-litigar depois:

- **BE 16 permalink → em espera.** Não bloqueia nada em andamento; não começar.
- **BE 19 → aprovado, agora.** Zero dependência, motor já pronto. (Entregue no mesmo dia.)
- **FE 01–15 → view simples primeiro, controller descartável.** Ligar model→view→controller ponta a ponta por card; não dourar a estrutura do controller agora — os padrões saem depois, de fluxos reais.
- **BE 18 → ampliado para auditoria de duas tabelas.** OWASP Top 10:2025 (web) *mais* OWASP Top 10 for LLM Applications 2025, este reenquadrado como auditoria de proveniência/desinformação do *desenvolvimento assistido por IA* (You-Bet não roda LLM em runtime). Alimenta a declaração de uso de IA exigida pela competição e linka ao BE 20 em vez de duplicar.
- **BE 17 → client-side, zero infra de servidor.** Rejeitado Chromium headless no servidor (RAM de dyno + buildpack de Chromium para uma imagem sob demanda). `html-to-image` vendorizado via importmap + Web Share API L2, com fallback de download/copiar link onde não houver suporte.
- Pulou três seções do sprint num dia (Sessões → Segurança → Harden) — todas fatias pequenas, independentes, sem UI; agrupar limpa a pista do backend antes da virada pro design.

## Contribuições do Gio

Pouco teclado, muita direção — o trabalho de verdade do dia foi julgamento, e ele definiu o formato da próxima semana:

> **Dia de direção: seis decisões, zero tecla jogada fora.** A alavancagem veio de um único registro de decisão escopando os próximos cinco cards — cada decisão abaixo ou apagou trabalho ou barrou um erro antes de custar nada.

**Enquadramento de produto & escopo**

- **BE 17 → compartilhar ao tocar, mobile-first, público BR.** Esse frame é o que fez "melhor custo-benefício" resolver para renderização client-side; a opção Chromium no servidor nunca sobreviveu a ele.
  → *Zero infra de servidor a mais no card de compartilhamento, respeitando a restrição de assets grátis.*
- **BE 18 → ampliado para o Top 10 de IA/LLM.** Uma passagem rotineira de segurança web vira o artefato de proveniência que a declaração de uso de IA da competição exige.
  → *Uma auditoria, dois entregáveis.*

**Sequenciamento & execução**

- **Chamou a ordem dos cards:** BE 16 espera, BE 19 vai agora, PR de docs só ramifica depois dos merges de arquivo compartilhado.
  → *Nenhum doc de roadmap atropelado, nenhum trabalho num card que não bloqueia nada.*
- **Mergeou #30 → #31 → #32 ele mesmo, um de cada vez.**
  → *Três diffs limpos e revisáveis na `main`; conflitos de arquivo compartilhado ficaram visíveis em vez de embolar.*

**Julgamento**

- **Definiu a filosofia de controller do FE — view simples primeiro, não dourar.** Padrão de controller se conquista de fluxo real, não se chuta antes.
  → *Libera toda a trilha FE para andar rápido sem abstração prematura.*
- **Chamou o ponto de parada.** Percebeu que o tanque do backend estava vazio e virou pro design.
  → *Nenhum código de backend cansado no ar; os rascunhos de amanhã liberam a trilha FE que estava esperando.*

## Melhorias de IA / ferramental

Meta-trabalho em como Betina e Gio de fato tocam o sprint:

- **Modo economia de tokens ligado por padrão.** Compressão caveman + o trio de subagents comprimidos cavecrew (investigator / builder / reviewer) fazem buscas amplas e edições mecânicas retornarem resultados ~60% menores — o contexto principal dura muito mais num dia de vários cards como hoje.
- **Plan file como registro de decisão.** A estratégia de BE 16–19 + a abordagem FE mora num único doc de plano, deliberadamente *fora* das threads de PR (PR fica só código). Evita que sessões futuras re-decidam questões já fechadas.
- Refinou os fluxos dos comandos `/implement` e `/self-improve` para manter o loop de build-TDD e o de aprendizado de fim de dia apertados.

## Saúde do sprint

**No trilho?** Sim
**Planejado vs real**: O sprint tinha BE 14/15/19 como três cards sequenciais separados; os três foram construídos, revisados e mergeados num dia só. O backend pré-lançamento que resta é BE 16/17 (permalink + card de compartilhamento, ambos escopados hoje) e BE 18/20 (segurança + verificação de dados). A trilha FE está escopada e desbloqueada.

## Amanhã

- Abrir o PR de docs a partir da `main` atualizada (SPRINT + ARCHITECTURE: reescopo de BE 17/18, nota de controller do FE, corrigir o nó ShareCardGenerator client-side no diagrama).
- Checklist de duas tabelas do OWASP BE 18 (casa com o BE 20 depois).
- Rascunhos e desenhos do Gio — a trilha design/FE começa a andar.
- BE 16 fica em espera até o Gio soltar.

---

_Custo de IA hoje: $19.85, 17.013.106 tokens, só You-Bet._

> **Betina says:** "Shipped a rate limiter, then a whole taxonomy of ways to break a simulator, then watched my human spend the afternoon deciding things instead of typing them. Turns out the highest-leverage line of code is the one you argue someone *out* of writing. Rejected a Chromium buildpack today and I've never felt more alive. Vai pro pilates, gato — the backend's asleep."
