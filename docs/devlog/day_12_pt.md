# Dia 12 — Consertar o papel, depois precificar a aposta

**Data**: 2026-07-07
**Fase do sprint**: Landing Page (cards de FE)
**Planejado**: FE-03 (input de valor semanal) era o card do board. Saiu de tarde — mas a manhã foi sequestrada por um conserto de paleta não planejado: as cores tinham derivado sem avisar, e bastou olhar os cards de verdade pra provar. Dois atos, um dia.

## TL;DR

- **Manhã — resgate da paleta.** A paleta light tinha ficado **apagada e amarelada** — todos os acentos dessaturados, o verde puxando pro amarelo, o "ink" virando magenta frio, os cards lavados sob um `#FFFDF8` quase branco. Puxei os valores reais do board `vibe.svg`, tirei o amarelo da base, re-saturei os acentos, re-derivei as variantes ink de texto que passam no AA.
- Persegui uma **textura de papel** de verdade metade da manhã — linhas de caderno → um erro de lixa → um hatch com ruído morno que finalmente lê como papel, não listras.
- Troquei os badges quadrados de `CASA %` por um **marca-texto passado à mão**, e montei um **sistema de trinkets** documentado (zonas de whimsy-vs-importância + um catálogo com regras de onde cada um entra). Levei uma correção sobre **autonomia demais no design** — transformei todo o vai-e-volta em docs de preview vivos.
- **Tarde — FE-03 saiu (PR #59).** O passo de valor semanal: quatro radio cards de faixa de gasto DataSenado (R$12/25/50/125) mais um campo custom em reais, um controller Stimulus `weekly-amount`, chaves en/pt-BR, specs de helper + request. Segundo passo do form, no idioma dos bet-cards do FE-02.
- **`required` nativo em vez de JS** — um grupo de radio já expressa "escolha um" de graça, então o controller só cuida do que a plataforma não faz: sync reais→cents e a checagem de maior-que-zero. O passe de design entregou **paridade do dot-pop** com o FE-02; a rampa de acento frio→quente da escada de gasto ficou **guardada** esperando um aval no DESIGN.md.

---

## O que foi feito

### A paleta estava mentindo

Um lado a lado com o board denunciou: a paleta do app não era mais o conjunto neon do `vibe.svg`. Um diff de HSL nomeou o crime exato — cada acento tinha perdido de 6 a 20 pontos de saturação, o verde tinha girado 14° pro amarelo, e o ink tinha virado de um marrom-quase-preto morno pra um cinza-magenta frio. Os cards ficavam sobre um `#FFFDF8` que lia como desbotado, não morno.

O conserto foi mecânico depois do diagnóstico: resetar cada token pros valores do board, baixar a saturação da base pro `bg` ler como papel (`#F8F6F2`) em vez de creme, restaurar o ink morno (`#1E1714`), e re-derivar as variantes ink de texto escurecidas o suficiente pra passar de 4.5:1 na base clara. A lavagem dos cards virou um token `--color-card` em vez de um literal mágico hardcoded em três lugares.

### Matando o painel Windows 98

Tirar o amarelo da base revelou o próximo problema: o painel do form, uma laje cinza chapada seis pontos mais escura que a página. Lia como cromo de sistema operacional. Levantar ele pra um papel de baixa saturação, um sopro acima do fundo — e deixar a borda, não um salto de tom, definir a aresta — devolveu ele pra família do papel.

### O longo caminho até a textura

A textura levou o maior número de iterações, e cada uma foi um sinal real, não enrolação. Linhas de caderno leem como *linhas*. Um passe de fractal noise em frequência alta saiu como **chuvisco de TV** — mais chapado e sujo, não mais rico. O conserto foi o contrário da intuição: manter as linhas finas de fibra, adicionar um *sopro* de ruído morno, e deixar as duas camadas **se sobreporem** pro olho parar de rastrear listras e ler textura. Em tom morno, não preto — porque linha preta em papel só faz cinza. Extraí tudo pra uma custom property `--paper-grain`, agora aplicada no body, no painel e nos cards igualmente.

### Trinkets, com regras

Os badges pareciam burocráticos demais, então o `CASA %` virou um marca-texto — o acento do próprio card, texto ink escuro, pontas irregulares e uma leve inclinação pra ler passado à mão. Isso abriu uma pergunta maior: onde o whimsy entra sem distrair da decisão de verdade? A resposta foi escrita como um **mapa de whimsy-vs-importância** (caminho da ação fica quieto, o cromo ganha capricho, zonas ambientes podem brincar) e um **catálogo de trinkets** — grain, marca-texto, perfuração, fita crepe, borda tracejada — cada um com sua restrição de posição. A regra dura: cards interativos ficam papel limpo; decoração vive em superfícies estáticas.

### FE-03 — precificando a aposta (PR #59)

Com a base limpa, a tarde foi pro card planejado: *quanto por semana?* O scaffold seguiu a forma do FE-02 — partial flat, controller Stimulus por seção, tokens `@theme` — então a forma era conhecida; as perguntas eram sobre validação e copy. Quatro âncoras de faixa de gasto DataSenado (R$12 / R$25 / R$50 / R$125) renderizam como radio cards, irmãos do `.bet-card`: papel, acento-ao-selecionar, e um beat `amount-pop` pro dot saltar como o checkmark do FE-02 (reduced-motion suprime). Um campo custom em reais deixa a pessoa nomear o próprio número.

A divisão da validação caiu da própria textura da plataforma: um grupo de radio já significa "escolha exatamente um", então o `required` nativo no grupo compartilhado `weekly_amount_cents` carrega isso de graça — sem a dança de `setCustomValidity` que o caso de ≥1-checkbox do FE-02 precisou. O controller Stimulus só cuida do que o HTML não faz: digitar no campo custom seleciona o radio dele, sincroniza reais→cents, e bloqueia o submit até o valor passar de zero. Specs de helper cobrem o mapa de âncoras e o label `R$12`; specs de request checam um radio required por âncora mais a linha custom. O form ainda está desligado (`url: "#"`) — ligar `weekly_amount_cents` a um atributo persistido é um card de BE depois.

---

## Decisões & viradas

- **`vibe.svg` é a fonte da verdade da paleta**, substituindo o hex amostrado antes.
  - Por quê — o conjunto amostrado tinha derivado pro apagado-e-amarelo; o board é a verdade.
- **Refinamentos de design são propostos, não inferidos.**
  - Por quê — escolher tons e parâmetros de textura sozinho queimou iterações e derivou; gosto é decisão do Gio. Opções agora vão como previews renderizados.
- **Trinkets são um sistema documentado, não firulas ad-hoc.**
  - Por quê — whimsy é estrutural, mas nunca pode competir com a ação principal; as restrições mantêm ele honesto.
- **Grain vive em todo papel**, com um refino de pilhas-de-papel-empilhado guardado pra depois.
- **FE-03 se apoia no `required` nativo, não em validação JS.**
  - Por quê — um grupo de radio codifica "escolha um" nativamente; refazer isso no Stimulus duplicaria a plataforma. O controller fica só com o sync reais→cents e o guard de maior-que-zero.
- **Rampa de acento da escada de gasto guardada, flip de hierarquia do card cortado.**
  - Por quê — a rampa frio→quente dobra a regra travada de não-choque-adjacente de acento, então precisa de aval no DESIGN.md antes; liderar cada card com a comparação humana em vez do R$ prejudica a leitura, então perdeu no trade. A paridade do dot-pop saiu; o resto espera.

---

## Contribuições do Gio

**Dia de direção em dois atos: o Gio conduziu cada decisão de design de manhã, depois definiu os guardrails de validação e escopo do FE-03 de tarde.**

**Produto & gosto (paleta):**
- **Apontou o `vibe.svg` como a paleta real** em vez de deixar uma amostra velha valer → resetou o sistema inteiro pra verdade do board.
- **Diagnosticou a podridão no olho — "apagado, amarelado, e não só o bg"** → disparou a análise de saturação/matiz que achou as três derivas.
- **Nomeou o "fundo Windows 98"** → o levante do painel.

**Feedback preciso:**
- **"Lê cinza, não papel — talvez camadas maiores"** e depois **"perdemos o pequeno aspecto de sobreposição que lê como textura, não linhas"** → o conserto exato do grain, em duas frases.
- **Trouxe uma referência de papel pra misturar** → ancorou a textura num visual real em vez de chute.

**Julgamento & guardrails:**
- **Apontou a autonomia demais nos refinamentos de design** → a correção de processo do dia, agora regra fixa.
- **Definiu as restrições dos trinkets** — fita não em caixas com drop-shadow, perfuração *sim* nelas, marca-texto pode aposentar um badge informativo demais, cards de ação ficam limpos → um sistema coerente em vez de efeitos soltos.
- **Cunhou "trinkets"** e liberou o marca-texto, cortou o dog-ear, guardou a ideia de pilhas de papel → manteve o escopo afiado.
- **Registrou um easter egg pra depois** (lata de Pepsi Black, canudo de papel listrado) → delícia de Zona C futura, anotada e não perdida.

**Validação & escopo (FE-03):**
- **Manteve a validação no `required` nativo, fora do JS** → o controller cuida só do sync reais→cents e do guard de maior-que-zero, nada que a plataforma já faça.
- **Guardou a rampa frio→quente de gasto atrás de um aval no DESIGN.md, cortou o flip de hierarquia do card como trade fraco** → a paridade do dot-pop saiu limpa; o polish que dobra a regra espera um aval explícito em vez de entrar escondido.

## Saúde do sprint

**No trilho?** Sim.
Dois atos entraram: um conserto de deriva de paleta não planejado que ia se acumular em todo card futuro, e o card FE-03 planejado por cima dele. Três dos cinco cards da Landing Page estão prontos.

**Planejado vs real**: FE-03 era o plano e saiu (PR #59, aberto pra review) — mais a correção de paleta não agendada da manhã e o sistema de trinkets. FE-03/04 herdam a base limpa e documentada que a manhã comprou.

## Amanhã

- Revisar + mergear #59 (FE-03) e #57 (este devlog); o PR de paleta/trinkets roda limpo.
- FE-04 (slider de prazo) a partir de `main` fresco — mesma house style (partial flat, Stimulus por seção, tokens `@theme`, i18n via values).
- Opcional: a rampa de escada de gasto guardada, se o aval do DESIGN.md vier; estender o grain pro visual de pilhas-de-papel quando sobrar folga.

---

_Custo de IA hoje: $31,91, 30.653.993 tokens (só you-bet)._

> **Betina diz:** "Consertei o papel pra ele parecer feito à mão, depois passei a tarde precificando quanto alguém aposta por semana — R$12, R$25, R$50, R$125, a escada DataSenado de dinheiro pequeno que nunca parece muito até você empilhar cinquenta e dois. Dois atos, mesma lição da paleta: é a pequena deriva semanal que você não percebe que leva o ano inteiro, quietinha."
