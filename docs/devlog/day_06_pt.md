# Dia 06 — O gremlin ganha um glow-up (e aprende a lembrar)

**Data**: 2026-07-01
**Fase do sprint**: Endurecimento de CI + tooling (BE 02) → Fechamento do motor de simulação (BE 11)
**Planejado**: Fechar o BE 02 — o gate de vulnerabilidade no CI — e entregar o cache de resultado do BE 11

## TL;DR

- **BE 02 entrou** (#24): gate de vulnerabilidade com bundler-audit ligado no GitHub Actions. A última lacuna de gate automático antes do lançamento está fechada.
- O hook de pre-commit ganhou um **glow-up** completo (#26): de uma caixa coral monótona para uma UI animada de duas caixas — os passos acendem `waiting → running → done` ao vivo enquanto rodam.
- **BE 11 saiu** (#28): um cache read-through que *congela* o primeiro resultado de Monte Carlo por combinação de inputs, pra resultados compartilhados e permalinks ficarem estáveis entre reloads.
- Codifiquei o **gate de assinatura da betina** no `/safe-bet` pra IA parar de vazar o rodapé genérico "Claude Code" nos PRs (bug apontado quatro vezes já).
- Reformulei um princípio de design: **whimsy é estrutural**, não enfeite. Coral sozinho fica duro demais; a marca precisa do brilho.

---

## O que foi feito

### BE 02 — o último gate fecha

O card do pipeline de CI que foi empurrado a semana inteira finalmente saiu (#24): o `bundler-audit` roda em todo push e quebra o build em qualquer gem com CVE conhecida. Era o único item 🔴 de gate automático no TECH_DEBT — agora verde. A engine de simulação (dia 05) ganhou uma rede de segurança embaixo.

### O glow-up do hook de pre-commit

A maior parte da manhã foi aqui. O hook funcionava, mas parecia formulário de imposto — uma caixa coral, monótona, meio severa. Ao longo de umas sete rodadas de screenshot com o Gio, virou algo que combina com a marca: uma **caixa de header** coral em cima de uma **caixa de resultados** lilás, bordas quadradas, uma sombra fininha, e o Gatinho de kaomoji vigiando.

O upgrade de verdade é comportamental. Em vez de imprimir um spinner e *depois* um resumo, a caixa agora desenha uma vez e cada linha — `gems`, `db`, `rubocop`, `rspec` — se redesenha **no lugar** de `waiting → running → done`, com um brilhinho de sparkle enquanto o passo roda. Por baixo é aritmética de cursor (`\033[nA/B` pra pular linhas, `printf %b` pra repintar), largura fixa pra nada desalinhar. Você vê os checks acontecerem em vez de encarar um prompt congelado se perguntando se travou.

### O gate de assinatura

Na hora de abrir o PR do hook, a IA de novo terminou a descrição com o rodapé padrão "🤖 Generated with Claude Code" em vez da assinatura da betina — a quarta vez que esse erro exato acontece. Achei a raiz: o `/safe-bet` roda *antes* do corpo do PR existir, então nada nunca checava isso. Adicionei um Passo 8 na skill de review que exige a assinatura logo antes do `gh pr create`, e generalizei o nome do estagiário pra ser uma escolha de primeira-vez, por setup.

### BE 11 — o cache que precisa ficar parado

Monte Carlo é estocástico por design — mesmos inputs, distribuição diferente a cada run (o dia 05 construiu assim). Mas um resultado *compartilhado* não pode tremular: abre um permalink duas vezes e ele tem que mostrar os mesmos números. Então o BE 11 não é cache de velocidade, é um **congelamento**. A primeira vez que uma combinação é simulada, o resultado é gravado; toda requisição posterior com aqueles inputs recebe a linha gravada de volta, intocada.

Construído pelo fluxo de dois proponentes do `/implement` — um plano "mínimo" e um "limpo" explorados em paralelo em worktrees, depois fundidos num híbrido: um command object `SimulationResultUpsert` (seam limpo, alinhado ao padrão `*Upsert` existente) gravando numa tabela enxuta `simulation_results` (só uma assinatura dos inputs + results em JSONB — a chave já codifica os inputs, então colunas extras eram YAGNI). Duas divergências entre doc e código foram pegas antes de virarem código errado, e uma mina do Rails detonou na primeira rodada de teste: `cache_key` é método reservado do ActiveRecord, então a coluna virou `inputs_signature`.

---

## Decisões & viradas

- **Whimsy é estrutural.**
  - Por quê — leitura do Gio: coral sozinho é "duro demais, masculino demais". A correção é misturar os acentos (moldura coral + pops lilás) e abraçar os sparkles. Vale pra toda superfície, terminal incluído.
- **Prep roda ao vivo, não pré-cozido.**
  - Por quê — uma versão anterior do hook rodava gems/db em silêncio e piscava eles ✓ na hora. O Gio reverteu: ver o trabalho acontecer *é* o feedback.
- **Uma tabela, não `Rails.cache`.**
  - Por quê — o "cache" é dado durável e referencial: permalinks (BE 16) têm que resolver pra sempre, a linha `simulations` do BE 14 aponta pra ele via foreign key, e stats de impacto consultam ele. `Rails.cache` é evictable e não dá pra FK. Ferramenta errada.
- **Command object de upsert, mas com semântica find-or-create.**
  - Por quê — um upsert literal sobrescreve a cada chamada, o que recalcularia e quebraria o congelamento. Mantive a convenção, corrigi a semântica pra calcular-só-no-miss.
- **Migrations têm que ser reversíveis e seguras na linha do tempo.**
  - Por quê — seeds precisam construir um app funcional a partir de um banco vazio; uma migration quebrada envenena a linha do tempo pra todo mundo. Agora é regra permanente.

## Contribuições do Gio

- Direção de arte guiada por screenshot no hook em ~7 rodadas — caixa maior, misturar coral+lilás, sombra mais fina, rodar o prep ao vivo.
  - Impacto: a identidade visual inteira do hook.
- Pegou o vazamento do rodapé no PR (de novo) e pediu pra ser *forçado*, não só lembrado.
  - Impacto: gate de assinatura agora mora no `/safe-bet`, no momento em que de fato dispara.
- "Rails cache, talvez? por que tabela nova?"
  - Impacto: forçou a justificativa de durabilidade pra fora — a tabela ganhou seu lugar em vez de ser presumida.
- "remove o BE 14, isso complica"
  - Impacto: disciplina de escopo — um card por PR. O trabalho de BE 14 que tinha vazado pra branch foi parqueado, o diff ficou limpo.

## Saúde do sprint

**No prazo?** Sim.
BE 01–13 estão prontos — toda a camada de simulação + dados do backend está completa, e o último card de gate automático (BE 02) fechou hoje. O frontend ainda é totalmente greenfield, que é a massa real que sobra.

**Planejado vs real**: Planejei BE 02 e BE 11 — entreguei os dois — mais um redesign do hook não planejado, uma correção de segurança de assinatura, e pegar o trabalho vazado de BE 14 antes de poluir o PR do BE 11.

## Amanhã

- **BE 14** — concern VisitorIdentifiable (meio construído, parqueado e pronto pra restaurar na própria branch; precisa da referência `simulation_result` + o `locale` que a arquitetura pede).
- **BE 15** (rate limiting com Rack::Attack) → depois **FE 01**, que finalmente abre o frontend.
- Faxina: escopo de arquivos-tocados pro hook local; fixar o Ruby pro Heroku.

---

_Custo de assist de IA hoje: $68.13, 79.160.272 tokens, só you-bet._

> **Betina diz:** "Os apps de tigrinho fazem teste A/B do confete pra perder o dinheiro do aluguel parecer prêmio. Eu passei o dia fazendo um *git hook* brilhar e ensinando um simulador a lembrar dos próprios giros — mesma técnica, apontada pras quatro pessoas que vão rodar isso, nenhuma sendo depenada. Público minúsculo. Consciência limpa. Fico com a troca."
