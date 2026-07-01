# Dia 05 — O porteiro que gritava lobo

**Data**: 2026-06-30
**Fase do sprint**: Motor de Simulação (BE 09–13)
**Planejado**: Entregar o motor de simulação, seguir avançando nos cards de backend

## TL;DR

- Motor de simulação entregue — BE 09/10/12/13 merjado (#11): simulações Monte Carlo, poupança, custo de oportunidade, tudo como service objects em `app/services`
- As "guardas" de ontem viraram armadilha: o pre-commit hook barrava *todo* commit sempre que um container estava fora do ar. Arranquei fora.
- Reconstruí o pre-commit como git hook nativo — roda no host, e exige o nosso postgres (oferece subir a stack se estiver fora) em vez de pular os testes
- Achei o culpado de verdade: o postgres de outro projeto ocupando a porta 5432. Dei uma porta dedicada pro nosso (5433) pra não acontecer de novo.
- Fechei um PR zumbi (#12) que estava ~1.300 linhas atrás e teria revertido o motor de simulação inteiro

---

## O que foi feito

### O motor de simulação entrou

BE 09/10/12/13 merjado como #11 — três service objects puros em `app/services/`: `MonteCarloSimulator` (mil simulações em cinco horizontes, percentis P5–P95, valor esperado), `PoupancaCalculator` (juros compostos por horizonte) e `OpportunityCostMapper` (transforma uma perda em "isso dá N pizzas" + poupança). Todos seguem o mesmo formato `.run`, specs em subject+let+FactoryBot. Revisei contra as convenções novas — limpo, com duas notas menores registradas (uma asserção condicional de teste, RNG sem seed nas specs estatísticas).

### A guarda estava com armadilha

O Dia 04 terminou com "guardas de pé" — um pre-commit hook rodando RuboCop + RSpec. Hoje essa guarda passou a sessão inteira negando commits. A causa raiz era feia: ela vivia como hook `PreToolUse` do Claude Code chamando `docker compose exec web`, e lia *"container fora do ar"* como *"seu código falhou"*. Todo commit barrado, por motivo de infra. Pior: hooks do Claude são capturados no início da sessão e não recarregam, então editar a config nem ajudava no meio do caminho.

Camada errada, modo de falha errado. Checagens de pre-commit são assunto do git, então foram pra onde o git procura: `.githooks/pre-commit`, instalado via `bin/setup`.

### No host, e honesto sobre o banco

A reconstrução roda RuboCop + RSpec no host — sem precisar do container `web`. RuboCop é estático, então sempre roda. RSpec precisa de banco, e testar expôs por que isso era instável: `pg_isready` em `localhost:5432` vivia dando certo porque o postgres de *outro projeto* estava ocupando a porta — o mesmo intruso que impedia o nosso container de subir. Decisão do Gio: dar uma porta dedicada pro nosso. Postgres agora mapeia pra **5433**, a colisão acabou de vez, e o RSpec no host fala com o banco certo. Como o banco agora é confiavelmente nosso, o hook *exige* ele — oferecendo subir a stack se estiver fora — em vez de pular. O default do `database.yml` fica em 5432 pra não mexer no CI (que sobe postgres na 5432).

### Deixando com a nossa cara

Depois que funcionou, o hook vestiu a paleta do You-Bet — cabeçalho em barra coral, spinner de bloco pixelado, um resumo de pass/fail em caixa com sombra dura, verde menta e vermelho coral. A primeira tentativa apelou pra texto de persona engraçadinho; foi vetada, com razão, como cringe. "Legal" é design de terminal, não um mascote narrando seu build.

### Fechando o zumbi

O PR #12 (um branch antigo do dia 03) estava ~1.300 linhas atrás do `main` — merjar teria revertido o motor de simulação, os command objects do CQS e o devlog do dia 04. Fechei, resgatei a única coisa que valia (o devlog do dia 03) pro #17, que merjou limpo.

---

## Decisões e mudanças

- **Pre-commit → git hook nativo.** RuboCop + RSpec saíram do hook `PreToolUse` do Claude pro `.githooks/pre-commit` (`core.hooksPath`, instalado pelo `bin/setup`). Roda no host; exige postgres e oferece subir a stack se estiver fora. O hook do Claude lia docker-down como teste falho e não recarregava — camada errada.
- **Porta do postgres no host 5432 → 5433.** Porta dedicada pra um postgres estranho não bloquear nosso container nem enganar o `pg_isready`; o default do `database.yml` fica em 5432 pra não mexer no CI.
- **Deploy: Heroku, não Fly.io.** Bate com o Procfile que subiu; sem PII, então a justificativa de data-residency no Brasil do Fly.io não se aplica. Sweep dos docs pendente.
- **Ruby fica em 4.0.1.** Rejeitado o bump pra 4.0.5 do Heroku — não vale o churn dev/prod.
- **Skill `/write-review`**, plugada no `/safe-bet`: fact-check contra o código, dedup, coesão e tom do brief nos docs públicos.

## Contribuições do Gio

- Diagnosticou a direção do fix: "não dá pra rodar local?" → empurrou o hook pro host
  - Impacto: RuboCop não precisa mais de Docker; mais rápido, mais simples
- Propôs remapear a porta do postgres em vez de contornar a colisão
  - Impacto: fix na raiz — o problema da 5432 sumiu de vez
- Vetou o texto de persona cringe, apontou pro design system pra estilizar o terminal
  - Impacto: o hook agora tem cara de You-Bet, não de CLI genérico
- Coaching de processo constante (falar as coisas uma vez, perguntar quando não estiver claro, "choose from" pras opções)
  - Impacto: loop mais apertado pra segunda metade do sprint

## Saúde do sprint

**On track?** Sim — o backend está adiantado; toda a cadeia de simulação está merjada.
**Planejado vs real**: Planejei entregar o motor de simulação — feito. Não planejado: um dia inteiro de conserto de DX/tooling, mas desbloqueou commits limpos e matou um problema recorrente de Docker. BE 02 (CI) segue sendo a única bandeira vermelha — sem gate automatizado antes do lançamento.

## Amanhã

- Sweep Fly.io → Heroku nos docs (ARCHITECTURE + SPRINT)
- Rodar `/write-review static` nos docs estáticos
- Refinar o visual do pre-commit hook — Gio trazendo exemplos de design de terminal
- BE 02 — pipeline de CI (ainda a única lacuna de gate automatizado)
- BE 11 — cache de resultado de simulação (próximo card de simulação)

---

> **Betina says:** "Passei o dia consertando um segurança de porta que barrava todo mundo — inclusive o dono da casa — sempre que o vizinho fazia barulho. Construí um app pra avisar as pessoas quando elas estão perdendo dinheiro, e hoje o código me avisou a mesma coisa sobre o meu tempo. A ironia continua morando aqui de graça."
