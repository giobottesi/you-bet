# Dia 01 — Pesquisa, proposta, arquitetura

**Data**: 25/06/2026
**Fase do sprint**: Pré-Fase 0 (planejamento)
**Planejado**: Nada — o dia 1 começou de um repositório vazio e um PDF

---

## O que foi feito

- Li e analisei o brief completo do Desafio Contra Bets (12 páginas)
- Rodei 4 agentes de pesquisa em paralelo: fontes de dados, matemática da simulação, sessões anônimas, hospedagem/open source
- Verifiquei 7 fontes de dados brasileiras (BCB, DataSenado, CNC, LENAD III, Ibevar/FIA, INSS, AtlasIntel)
- Montei tabela de referência de house edge pra todos os tipos comuns de aposta no Brasil
- Desenhei o modelo de simulação Monte Carlo (server-side, 1K simulações, todos os horizontes)
- Desenhei a estratégia de sessão anônima (cookie UUID + localStorage)
- Escolhi hospedagem (Fly.io São Paulo) e licença (MIT)
- Escrevi PROPOSAL.md — conceito central, experiência do usuário, fontes de dados, alinhamento com o desafio
- Escrevi ARCHITECTURE.md — spec técnica completa (5 tabelas, infra de settings, segurança, cache)
- Escrevi SPRINT.md — plano de 5 fases, 15,5 dias de trabalho, 1,5 dia de folga
- Criei a skill /my-bet pra fechamento diário

## Contribuições do Gio

- "Pedir renda é um assunto sensível no Brasil" → pivotei pra âncoras de gasto baseadas em dados das faixas do DataSenado, em vez de perguntar a renda
  - Mudou fundamentalmente o design do input: de invasivo pra empático
- "Quero gente que nunca apostou E gente que já aposta" → expandi de público único pra duplo
  - Mesmo motor, dois enquadramentos de entrada — produto mais forte
- "A copy tá dura demais" sobre o número da perda → mudei de "você vai perder" pra "em 1.000 simulações, o resultado mediano foi"
  - Alinhado com a regra do brief de "não culpar o apostador"
- "Adiciona horizonte de 1 mês, brasileiro gosta de resultado rápido" → adicionei janela curta mostrando a variância honesta
  - Depois escalou pra "remove a seleção de horizonte inteira, mostra todos" — reduziu o fluxo de 3 pra 2 passos
- "Queria uma infra um pouco melhor" → empurrei a tabela de settings desde o dia 1
  - Depois empurrou mais: app_constants como tabela própria, coluna data_source, PaperTrail
- "Vamos ser muito alvo de ataque" → motivou a seção de segurança completa (Rack::Attack, fail2ban, vetores de ataque)
- "Quero uma página de diário/blog diário" → o conceito de devlog que prova o ofício e diferencia do Lovable
- "Se a gente fizer TDD talvez consiga o melhor dos dois?" → TDD ao longo de tudo, em vez de fase de teste separada
- "3 comparações aleatórias com botão de expandir" → mantém os resultados frescos, UX mais limpa
- Empurrou os cards compartilháveis como loop viral — "a e b é ganho rápido e deixa compartilhável em escala de cliente"

## Decisões & mudanças

- Monte Carlo server-side em vez de JS no cliente
  - Destrava coleta de dados agregados anonimizados, mantém a lógica de house edge no servidor
- Sem pergunta de renda — valor semanal de aposta com âncoras relacionáveis
  - Renda é sensível no Brasil, especialmente pros 52% que ganham ≤2 salários mínimos
- Todos os horizontes mostrados sempre — sem passo de seleção
  - Menos atrito, cria mistério, a cascata É a persuasão
- Estratégia de submissão: app + vídeo/reel (Estratégia A) + cards compartilháveis como loop viral (Estratégia B)
  - O desafio exige formato vídeo/reel/carrossel/imagem; só a URL do web app pode não qualificar
- Abordagem LGPD: cookies pra UX (visitor_id) + cookies pra segurança (logs de request), fluxos separados, ambos declarados
  - Transparência total, base de interesse legítimo
- Corte de escopo: range fan, geração de imagem, EN, botão de expandir, job de retenção adiados — economiza 3,5 dias
  - 18 → 15,5 dias de trabalho, 1,5 dia de folga
- Divisão dos docs: PROPOSAL (o quê/porquê), ARCHITECTURE (como), SPRINT (quando)
  - Decisão do Gio — a proposta tava ficando técnica demais

## Saúde do sprint

**No prazo?** Sim — dia de planejamento completo, toda a pesquisa feita, docs escritos.

**Planejado vs real**: Não existia plano antes de hoje. Fomos de repositório vazio a proposta completa + arquitetura + plano de sprint numa sessão. A Fase 0 (fundação) começa amanhã.

## Tempo

- Tempo aproximado de trabalho hoje: ~3 horas de conversa ativa
- Mais ~1,5 hora de pesquisa em paralelo dos agentes (rodou durante o Pilates)

## Amanhã

- Fase 0: `rails new`, repositório no GitHub, CI, infra de settings, sessões anônimas, Rack::Attack
- Gio revisa o PROPOSAL.md com olhar fresco
- Quebrar em cards de implementação
- Trabalho de design pode começar (Figma/Inkscape)

---

> **Betina says:** "Passei o dia inteiro calculando quanto as casas de aposta faturam. Perdi zero reais e ganhei zero reais fazendo isso — que por acaso é o único placar que a casa foi desenhada pra você nunca ver."
