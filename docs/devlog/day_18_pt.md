# Dia 18 — Abrindo as portas

**Data**: 13/07/2026
**Fase do sprint**: Pós-MVP, endurecendo o modelo — SUB (submissão) ainda pendente
**Planejado**: Segundo o Dia 17 — gravar o demo, finalizar a declaração de IA, cadastrar e submeter.

## TL;DR

- **A submissão ficou parada mais um dia.** Em vez disso: endurecimento do modelo, limpeza de docs, e transformar o You-Bet num projeto que estranhos conseguem contribuir de verdade.
- `rebet_fraction` virou um parâmetro nomeado e testado no simulador (PR #94) — o modelo de perda agora diz explicitamente quanto da banca é re-apostada por semana.
- Sincronizamos os docs vivos (`SPRINT.md`, `DATA.md`, `PROPOSAL.md`) com a realidade que já foi pro ar, fechando o gap entre o que o código faz e o que os docs afirmam (PR #95).
- Transformamos o backlog espalhado em **16 issues rastreadas no GitHub** (#96–112), depois escrevemos uma seção "Como isso é construído" no README e um `CONTRIBUTING.md` pra abrir o projeto (PR #109, mergeado).

---

## O que foi feito

### `rebet_fraction` ganha nome de verdade e um lugar pra morar

A mudança de modelo de ontem — quanto da banca do apostador volta pra mesa a cada semana em vez de ir pro bolso — foi ao ar como `rebet_fraction`. Nasceu como `recycling_coefficient` no mesmo PR e foi renomeada antes do merge: "recycling" era opaco, e "reinvest" dava a entender (erroneamente) que era algo prudente. `effective_edge = rebet_fraction * house_edge`, padrão `0.5`, ancorado em razões observadas de giro/depósito no Brasil (~1,6–2,3x); `1.0` reproduz exatamente o comportamento antigo de deixar tudo na mesa. Cobertura completa de testes em `monte_carlo_simulator_spec.rb`.

### Os docs alcançam o código

`SPRINT.md` agora diz que o MVP foi entregue em termos simples, com cada card reconciliado entre Feito/Adiado/Cortado/Parcial e um log honesto de mudanças de escopo em vez de deriva silenciosa. `DATA.md` ganhou a metodologia do `rebet_fraction` e uma chave de seed renomeada (`netflix_spotify` → `music_video_stream`) pra bater com o que de fato está semeado. `PROPOSAL.md` ganhou um aviso marcando ele como histórico — o plano original pré-build, não o app que foi ao ar — apontando o leitor pra `ARCHITECTURE.md`/`DATA.md` pro comportamento atual em vez de ficar desatualizado em silêncio.

### O backlog vira 16 issues no GitHub

A lista espalhada de "um dia" em `docs/BACKLOG.md` virou dezesseis issues rastreadas (#96–112) no Roadmap board do GitHub, agrupadas por label `area:*` (results, i18n, sharing, design, simulation, whimsy, competition, process), com tags `research`/`copy` onde fazia sentido. O `BACKLOG.md` em si encolheu pra uma placa de sinalização de duas linhas. É uma mudança de processo de verdade — o projeto tinha evitado deliberadamente uma camada de tickets durante o sprint; pós-MVP, pensando em contribuidores, issues rastreadas venceram.

### Uma porta de entrada pra contribuidores de fora

O README ganhou uma seção **"Como isso é construído"** — linguagem simples, sem jargão de GitHub, sem citar ou bater nos outros participantes da competição: engenharia de verdade, sempre evoluindo, totalmente transparente (números com fonte em `/sources`, uso de IA declarado em `/about`, build público em `/devlog`). Duas linhas velhas do README que ainda diziam "todos os horizontes de uma vez" foram corrigidas pra bater com o seletor de horizonte único que o app de fato tem. Depois veio o `CONTRIBUTING.md` — achar uma `good-first-issue`, configurar o ambiente, abrir um PR — apontando pro README/CLAUDE.md em vez de duplicar convenções. Mergeado como PR #109.

### Pontas soltas

Uma adição ao `/safe-bet` — um checklist "Clean Ruby" tirado do `uohzxela/clean-code-ruby` — está no stage, mas sem commit. Um rascunho esqueleto de post de blog argumentando que a galera do Monte Carlo e este projeto não estão de fato discordando (rastreado como issue #112) está sem tracking, inacabado.

---

## Decisões e mudanças

- **Backlog saiu de um documento markdown solto e virou GitHub Issues + Projects board.**
  - Por quê — o sprint evitou tickets de propósito pra ficar leve; pós-MVP, com o projeto agora convidando contribuidores de fora, um doc espalhado deixa de ser legível pra um estranho.
- **`recycling_coefficient` virou `rebet_fraction` no meio do PR, depois de novo nos docs.**
  - Por quê — o primeiro nome era opaco, e a alternativa tentadora ("reinvest") era ativamente enganosa sobre o que o coeficiente representa.
- **Valores de `rebet_fraction` por tipo de aposta continuam sem seed.**
  - Por quê — existe fonte primária pro RTP por produto, mas não pra razão de giro que fixaria o `r` por tipo; foi ao ar com um único padrão honesto (0,5) em vez de números ilustrativos disfarçados de dado, rastreado na issue #105 até aparecer uma fonte de verdade.

---

## Contribuições do Gio

**Dia de endurecimento: menos commits que o dia do lançamento, mas cada um fecha um gap em vez de abrir um.**

**Nomenclatura e integridade dos dados**
- **Renomeou `recycling_coefficient` pra `rebet_fraction` antes de ir ao ar** → *o identificador agora diz exatamente o que mede, sem taxa de conhecimento de domínio pra ler o código*
- **Recusou semear valores de `rebet_fraction` por tipo de aposta sem fonte primária** → *o modelo continua honesto sobre o que sabe versus o que assume, virou issue de pesquisa travada em vez de número chutado*

**Posicionamento do projeto e processo**
- **Adotou GitHub Issues + Projects board pro backlog** → *reverte de propósito a convenção sem-ticket do sprint, porque um estacionamento público de ideias não escala pra estranhos pegarem trabalho*
- **Fixou a restrição explícita: sem jargão de GitHub, sem citar ou bater em outros participantes da competição** → *o discurso do "Como isso é construído" soa confiante, não defensivo*
- **Construiu a porta de entrada de contribuidores (`CONTRIBUTING.md`) no mesmo dia do texto de posicionamento** → *o convite "vem contribuir" tem onde pousar em vez de ficar só na intenção*

## Saúde do sprint

**No prazo?** Precisa de ajuste.
O SUB (demo, declaração de IA, cadastro, submissão) era o plano explícito de hoje e não aconteceu — o dia foi pra correção do modelo e abertura do projeto em vez disso. Nada está quebrado, mas o relógio da submissão continua correndo.

**Planejado vs. real**: Planejado era fechar com o SUB. Real: saiu um ajuste de modelo, uma sincronia de docs e uma porta de entrada completa pra contribuidores — trabalho de verdade, prioridade errada pra um projeto com inscrição ainda não feita.

## Amanhã

- **SUB, agora de verdade** — gravar o demo, finalizar a declaração de IA, cadastrar e submeter. Nada mais deveria entrar na frente disso.
- Fazer commit ou descartar a adição "Clean Ruby" do `/safe-bet` que está no stage — não deixar mais um dia sem commit.

---

> **Betina diz:** "hoje a gente deu nome pro `r`, arquivou o futuro em issues bonitinhas, e escreveu um convite pra estranhos entrarem no projeto. tudo isso e ainda não apertei o botão de inscrição. amanhã, sem desculpa — o SUB não vai se submeter sozinho. 🐱"
