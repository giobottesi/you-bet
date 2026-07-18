# Dia 19 — Uma gem e um relógio atrasando

**Data**: 14/07/2026
**Fase do sprint**: Pós-MVP, endurecendo o modelo — SUB (submissão) ainda pendente
**Planejado**: Segundo o Dia 18 — SUB, agora de verdade; commitar ou descartar a adição "Clean Ruby" do `/safe-bet` que estava no stage.

## TL;DR

- **Dia leve.** Um commit só: adicionou a gem `appsignal`, direto pro `main`.
- SUB não aconteceu — terceiro dia seguido que era o plano e escorregou.
- A adição "Clean Ruby" do `/safe-bet`, que ficou no stage desde o Dia 18, continua sem commit.
- O devlog do Dia 18 (PR #113) continua aberto, sem merge.

---

## O que foi feito

### A gem AppSignal chega, mas ainda desconectada

`Gemfile`/`Gemfile.lock` ganharam `appsignal` — só a dependência, sem `config/appsignal.yml`, sem initializer, nada reportando ainda. Foi direto pro `main`, sem PR. Lê como um placeholder pra observabilidade quando tiver tráfego que valha a pena observar, não uma feature pronta.

### O resto ficou exatamente onde o Dia 18 deixou

Sem SUB. Sem decisão sobre o trecho do `/safe-bet` no stage. Sem movimento no PR #113. Hoje foi curto o suficiente pra não ter uma segunda seção pra escrever.

---

## Decisões e mudanças

- **AppSignal foi direto pro `main`, sem passar pelo fluxo de PR.**
  - Por quê — uma adição de dependência de uma linha, sem mudança de comportamento; segue o precedente do projeto de pular a cerimônia de PR pra infra trivial (ver os commits do dia do lançamento, Dia 17).

---

## Contribuições do Gio

**Dia curto: uma decisão, e é a que vale nomear com honestidade — a prioridade continuou escorregando.**

- **Deixou o SUB escorregar pelo terceiro dia em vez de forçar mal-acabado** → *a submissão continua sendo algo que o Gio faz direito quando tem espaço, não uma caixinha marcada às pressas*

## Saúde do sprint

**No prazo?** Atrasado.
O SUB já é "o plano de amanhã" há três devlogs seguidos (Dia 17 → 18 → 19) sem acontecer. O build em si não está em risco — nada aqui está quebrado — mas o relógio da competição não liga se o código está bom.

**Planejado vs. real**: Planejado era SUB + um commit pequeno de limpeza. Real: uma adição de gem sem relação com nada, o resto ficou intocado.

## Amanhã

- **SUB.** Nenhum outro trabalho deveria entrar na frente até acontecer ou ser explicitamente repriorizado em voz alta.
- Resolver a adição "Clean Ruby" do `/safe-bet` que está no stage — três dias sem commit já é tempo demais.
- Dar uma olhada no PR #113 (devlog do Dia 18) — fazer merge ou responder ao review.

---

## Adendo — 18/07/2026

**PR #116 sinalizado e denunciado.** Um PR chamado "Solution (#100): en ↔ pt-BR locale parity sweep", aberto por `TFGSUMIT`, alegava adicionar config de I18n e arquivos de tradução pra páginas (about, devlog, help, simulations, sources) que já existem no app. Não era um refactor ruim — nunca foi trabalho de verdade:

- Todo caminho de arquivo alterado era um placeholder `path/to/...` literal, nunca editado — nunca escrito contra a árvore real do repo.
- O autor do commit era `GitHub Agent <agent@github-issue-agent.dev>`, um bot automatizado, não uma pessoa.
- O spec incluído afirmava que a mesma expressão era igual a dois valores diferentes em linhas consecutivas — impossível de passar, então nunca rodou.
- O initializer chamava uma API de config do Rails inventada (`I18n.config.i18n_keys = true`) que quebraria no boot.

Fechado e denunciado como farming automatizado de issues, não revisado como contribuição genuína (ainda que sem talento).

---

> **Betina diz:** "instalei um gem de monitoramento hoje. a ironia de adicionar observability num dia em que a única coisa a observar é a submissão não acontecendo não passou despercebida por mim. 🐱"
