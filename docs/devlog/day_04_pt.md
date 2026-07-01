# Dia 04 — Separação leitura/escrita, guard-rails de pé

**Data**: 2026-06-29 (entrando na madrugada de 06-30)
**Fase do sprint**: Data Infrastructure → Simulation Engine (preparação do BE 09)
**Planejado**: BE 02 (CI), BE 05 (CLAUDE.md), BE 09 (MonteCarloSimulator core), resolver o rename do `BETTING_TYPES`

## TL;DR

- Não escrevi o BE 09 — passei a sessão deixando o BE 09 *seguro de escrever*: um split CQS de leitura/escrita e um contrato de pipeline documentado
- `reference_values` ganhou uma coluna `bet_type` de verdade com índices únicos parciais; house edges agora são pares `(bet_type, key)`, não chaves stringly-typed `bet_type.x.house_edge`
- Renomeei `BetTypeUpsert → ReferenceValueUpsert` — um command de escrita genérico pra todo dado de referência; `BetType` virou um read value object puro
- Endureci o workflow: skill de review `/safe-bet`, um pre-commit hook que realmente bloqueia, `bin/docker-up`, e um ledger `TECH_DEBT.md`
- 50 specs verdes; whole-chain, sem stubs — a suíte agora é o tripwire do pipeline forward-only

---

## O que foi feito

### Guard-rails de tooling antes de mais código (#13)

Três correções de processo que vinham incomodando em silêncio:

- **Skill de review `/safe-bet`** — codifica o passo pré-PR: coerência, duplicação, info sensível, convenções. O gate de branch-pra-PR agora é checklist, não vibe.
- **Correção do pre-commit hook** — o hook antigo usava um campo `"if"` não-funcional, então RuboCop + RSpec nunca bloqueavam de fato. Troquei por um match de comando via `jq` pros checks rodarem no `git commit` e em lugar nenhum mais (estavam disparando em toda chamada de Bash).
- **`.gitignore` no `settings.local.json`** — esse é um repo público; paths de máquina, permissões e MCP servers estavam a um `git add .` de vazar.
- **`bin/docker-up`** — codifica a dança manual de recuperação "port already allocated / server.pid exists": mata containers em conflito, limpa o pidfile velho, `compose up -d`.

### TECH_DEBT.md — um ledger de débito

Comecei um ledger corrido dos itens conscientemente adiados pra "a gente sabe, tá na lista" ter uma fonte da verdade. Quatro linhas no primeiro dia: seeds em arquivo único que colidem entre PRs, o ponto cego do hook quando o docker tá down, a política de precisão float-vs-BigDecimal ainda indecisa, e o BE 02 (CI) ainda pulado (o único 🔴 — sem gate automático no push ainda).

### Preparação do BE 09 — o split leitura/escrita (o trabalho de verdade)

O BE 09 (Monte Carlo) lê house edges em toda request. Antes de construí-lo, a camada de dados precisava de uma espinha pro hot path ficar enxuto. Esse refactor:

- **Coluna `bet_type` + índices únicos parciais** — `unique (key) where bet_type IS NULL` pra dado de comparação, `unique (bet_type, key) where NOT NULL` pra métricas de aposta. Um bet type pode ganhar mais métricas (edge min/max, variância) depois sem colisão de chave.
- **`ReferenceValueUpsert`** — renomeado de `BetTypeUpsert` e generalizado. Um command de escrita `ActiveModel` pra *todo* dado de referência: valida presença + inclusão de `value_type`, dá upsert via `find_or_initialize_by(key:, bet_type:)`. Todos os seeds passam por ele.
- **`BetType` agora é read object puro** — sem tabela, lê `house_edge_value` via a coluna `bet_type`. `BetType.create` é uma fachada fina sobre o upsert. Leituras fluem pelo pipeline; escritas vivem fora do caminho da request.
- **`SeedData`** — todo conjunto de seed extraído pra um lugar só; `db/seeds.rb` agora é loop sobre `ReferenceValueUpsert`.

Isso é CQS na prática: os objetos que viajam pelo flow da request não incham, porque escrever é trabalho de outro.

### ARCHITECTURE.md — o contrato do pipeline

Documentei a restrição que o código agora impõe: um **pipeline unidirecional, forward-only**. Dado só anda pra frente, as folhas (`ReferenceValue`, `AppConfig`) são leituras puras, composição é livre mas back-reference é proibido. Tracei a request inteira de simulação como uma linha só, codifiquei leitura-vs-escrita (CQS), e escolhi audit-log no lugar de event-sourcing (pub-sub completo é YAGNI pra um simulador síncrono). A regra pro contribuidor: comportamento novo é um stage novo pra frente ou uma folha pura — nunca um callback pra cima. Specs estressam a chain inteira, sem stubs.

---

## Decisões & mudanças

- Pivotei de "escrever BE 09 hoje" pra "deixar o BE 09 seguro de escrever"
  - Por quê — construir o Monte Carlo em cima de chaves stringly-typed `bet_type.x.house_edge` e de um caminho de escrita no seed-file teria assado o coupling no hot path. Mais barato consertar a fundação agora do que refatorar através do simulador depois.
- `bet_type` como coluna de primeira classe, não prefixo de chave
  - Por quê — pares `(bet_type, key)` deixam um bet type ter várias métricas sem colisão; o esquema de prefixo não conseguia.
- Resolvi o rename `BETTING_TYPES` vs `TYPES` — mantive `BETTING_TYPES` como a constante em `BetType`
  - Por quê — era o blocker aberto no PR do be-07; `BETTING_TYPES` lê sem ambiguidade.

## Contribuições do Gio

- Empurrou o ledger de tech-debt em vez de deixar os adiamentos morando na nossa cabeça
  - Impacto: 4 itens rastreados, incluindo o gap 🔴 de CI que é fácil esquecer até o launch
- Conduziu o catch de higiene de repo público (`settings.local.json`)
  - Impacto: fechou um vazamento de credencial/path antes de acontecer num repo público

## Saúde do sprint

**No prazo?** Sim — trabalho de fundação, não scope creep.
Uma frase: o BE 09 escorregou um dia, mas agora tá desbloqueado em cima de um contrato leitura/escrita limpo em vez de ser construído na areia.

**Planejado vs real**: BE 02 e BE 05 ainda pendentes; BE 09 não iniciado mas de-riscado. Troquei velocidade bruta de card por uma fundação que impede a chain de simulação (BE 09–13) de herdar coupling.

## Amanhã

- BE 09: MonteCarloSimulator core — agora genuinamente desbloqueado; `BetType#house_edge_value` é a única leitura que ele precisa
- BE 02: pipeline de CI (o 🔴 do ledger — fechar antes do launch)
- Abrir o PR do be-07 agora que o rename tá resolvido
- Atualizar o roadmap do SPRINT.md — ainda mostra só BE 01 como done

---

> **Betina says:** "Passei o dia desenhando regras pra dados não andarem pra trás, num app sobre dinheiro que só anda pra trás. A diferença é que aqui os dados não são viciados pra casa sempre ganhar."
