# Dia 03 — Camada de dados pronta, dia de migração

**Data**: 2026-06-28
**Fase do sprint**: Infraestrutura de Dados (BE 03–08)
**Planejado**: BE 02 (CI), BE 03 (i18n), BE 06 (AppConfig), BE 07 (ReferenceValue)

## TL;DR

- Entregou BE 03, BE 04, BE 06, BE 07 e BE 08 — cinco cards em uma sessão
- Models AppConfig e ReferenceValue no ar com seeds, type casting e cobertura de testes completa
- Value object BetType encapsula house edges com clareza — sem lookups brutos no banco nos callers
- Seeds refatoradas para extrair constantes, ficou muito mais legível
- Migrou setup do Claude do perfil da empresa para o pessoal — perfil, memórias e configurações

---

## O que foi feito

### i18n e deploy (BE 03 + BE 04)

Configurou pt-BR como locale primário com RSpec configurado. EN stubado para quando precisar — sem strings para traduzir ainda, mas a infraestrutura está pronta.

Primeiro deploy entregue (PR #8). Observação: acabou usando um Procfile do Heroku em vez do Fly.io como planejado no ARCHITECTURE.md. Vale confirmar qual host está de pé e atualizar a documentação.

### Model AppConfig (BE 06)

Model para constantes do sistema: número de simulações Monte Carlo, taxa da poupança, salário mínimo, período de retenção de dados. Destaques:

- `typed_value` — retorna o tipo Ruby correto (integer, float, BigDecimal, string) com base em `value_type`
- `.fetch(key)` — levanta `RecordNotFound` para chaves inexistentes, sem nils silenciosos
- `SEED_DEFAULTS` extraído para uma constante — seeds leem como uma tabela, não como código imperativo
- Seeds são idempotentes (`find_or_initialize_by`) — seguro rodar em qualquer ambiente, quantas vezes quiser
- Cobertura RSpec completa: validações, type casting, idempotência das seeds

### Model ReferenceValue (BE 07)

Model para dados externos citados: preços de referência e house edges dos tipos de aposta. Cada registro tem `data_source` — todo número no app cita sua origem.

Duas constantes de seed: `SEED_COMPARISON_VALUES` (10 preços do iFood, Apple BR, DIEESE etc.) e `SEED_BET_TYPE_VALUES` (7 house edges com notas metodológicas). Mesmo padrão de idempotência com `find_or_initialize_by`.

Scope `.by_category` adicionado para filtrar comparison vs bet_type.

### Value object BetType (BE 08)

Classe Ruby pura — sem herança de AR, sem tabela. Encapsula os 7 tipos de aposta suportados e delega o lookup de house edge para `ReferenceValue`. Expõe `display_name` via i18n com fallback razoável.

Métodos de classe `.all` e `.find` seguem a interface do ActiveRecord para que os callers não precisem saber que não é um model do banco. `ArgumentError` em chave inválida — falha rápida, sem comportamento silencioso.

### Refatoração das seeds

Extraiu todos os dados de seed para constantes `SEED_*` nos models. O `db/seeds.rb` saiu de um bloco de hashes repetitivos para três loops legíveis. Idempotência agora é responsabilidade do model, não do arquivo de seeds.

### Migração do perfil do Claude

Moveu a configuração do Claude do perfil da empresa para o pessoal:
- `~/.claude-personal/CLAUDE.md` — perfil completo de dev com estilo de código, regras de resposta, tom
- `~/.claude-personal/settings.json` — model (`opus[1m]`), voz, tema (`dark-ansi`), plugin ruby-lsp
- `~/.claude-personal/statusline-command.sh` — branch git + model + ctx% na status bar
- Importou 9 memórias do projeto do perfil da empresa para o pessoal
- Extraiu 4 novas memórias da codebase: status do sprint, design system, gem stack, issues abertas

---

## Decisões e mudanças

- Seeds como constantes do model, não no `db/seeds.rb`
  - Mantém os dados colocalizados com o model — mais fácil de encontrar e atualizar, sem troca de contexto
- BetType como value object Ruby puro, não ActiveRecord
  - Sem necessidade de tabela. House edges ficam em `reference_values` onde podem ser atualizados sem deploy.
- Heroku em vez de Fly.io no deploy
  - Contradiz o ARCHITECTURE.md — precisa de verificação e atualização da documentação

---

## Contribuições do Gio

- Pediu seeds extraídas para constantes ("I would like to see this cleaner") → dados de seed muito mais legíveis
- Iniciou a migração do perfil do Claude → portabilidade total do setup entre trabalho e contexto pessoal
- Percebeu a necessidade de importar as memórias do perfil da empresa → 9 memórias restauradas, 4 novas extraídas da codebase

## Saúde do sprint

**On track?** Sim — levemente adiantado na fase de infraestrutura de dados.

**Planejado vs real**: BE 02 (CI pipeline) foi pulado para avançar mais rápido na camada de dados. BE 02 (bundler-audit, GitHub Actions) ainda está pendente. BE 07 e BE 08 foram feitos no mesmo commit, economizando uma sessão. O roadmap do sprint no SPRINT.md precisa de atualização — ainda mostra só o BE 01 como concluído.

## Amanhã

- Resolver o rename da constante `BETTING_TYPES` vs `TYPES` antes de abrir o PR do be-07
- BE 02: CI pipeline — GitHub Actions + bundler-audit (desbloqueado, card rápido)
- BE 05: CLAUDE.md — instruções do projeto (desbloqueado, card rápido)
- BE 09: MonteCarloSimulator core — o card principal; desbloqueia toda a cadeia de simulação
- Atualizar o roadmap do SPRINT.md para refletir o estado atual

---

> **Betina diz:** "Hoje construí a fundação de dados do app: preços de pizza, bordas de cassino, e quanto custa um iPhone no Brasil. Não sei o que diz mais sobre o Brasil — que o iPhone custa R$5.500 ou que tem gente apostando isso por semana."
