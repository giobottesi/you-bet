# Dia 12 — Fazer o papel virar papel

**Data**: 2026-07-07
**Fase do sprint**: Landing Page (cards de FE)
**Planejado**: Nada agendado — FE-03/FE-04 eram os próximos no board. O dia virou um conserto não planejado: a paleta tinha derivado sem avisar, e bastou olhar os cards de verdade pra provar.

## TL;DR

- A paleta light tinha ficado **apagada e amarelada** — todos os acentos dessaturados, o verde puxando pro amarelo, o "ink" virando magenta frio, os cards lavados sob um `#FFFDF8` quase branco.
- Puxei os valores reais do board `vibe.svg`, tirei o amarelo da base, re-saturei os acentos de volta ao neon, e re-derivei as variantes ink de texto que passam no AA.
- Persegui uma **textura de papel** de verdade metade do dia — de linhas de caderno, passando por um erro de lixa, até um hatch com ruído morno que finalmente lê como papel, não listras.
- Troquei os badges quadrados de `CASA %` por um **marca-texto passado à mão**, e montei um **sistema de trinkets** documentado (zonas de whimsy-vs-importância + um catálogo com regras de onde cada um entra).
- Levei uma correção sobre **autonomia demais no design** — e transformei todo o vai-e-volta em docs de preview vivos.

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

---

## Decisões & viradas

- **`vibe.svg` é a fonte da verdade da paleta**, substituindo o hex amostrado antes.
  - Por quê — o conjunto amostrado tinha derivado pro apagado-e-amarelo; o board é a verdade.
- **Refinamentos de design são propostos, não inferidos.**
  - Por quê — escolher tons e parâmetros de textura sozinho queimou iterações e derivou; gosto é decisão do Gio. Opções agora vão como previews renderizados.
- **Trinkets são um sistema documentado, não firulas ad-hoc.**
  - Por quê — whimsy é estrutural, mas nunca pode competir com a ação principal; as restrições mantêm ele honesto.
- **Grain vive em todo papel**, com um refino de pilhas-de-papel-empilhado guardado pra depois.

---

## Contribuições do Gio

**Dia de direção: o Gio conduziu cada decisão de design, a IA só segurou o pincel.**

**Produto & gosto:**
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

## Saúde do sprint

**No trilho?** Sim, com asterisco.
Isso não era um card de FE planejado — era um conserto de deriva de paleta que ia se acumular em todo card futuro se ficasse assim. Valeu o desvio; o design system agora está documentado em vez de tribal.

**Planejado vs real**: FE-03/FE-04 eram os próximos; em vez disso a paleta foi corrigida e o sistema de trinkets foi construído e escrito. FE-03/04 agora herdam uma base limpa e documentada.

## Amanhã

- Revisar + PR do trabalho de paleta/trinkets (safe-bet já rodou limpo).
- De volta ao board: FE-03 (input de valor semanal) e FE-04 (slider de prazo).
- Opcional: estender o grain pro visual de pilhas-de-papel quando sobrar um tempo.

---

_Custo de IA hoje: $17,47, 18.813.287 tokens (só you-bet)._

> **Betina diz:** "Passei um dia inteiro ensinando o papel de um app de aposta a parecer mais papel, o que é ou o trabalho mais honesto que já fiz ou o menos — um branco-morno fingindo ter fibra, pra que os números sobre como a banca sempre ganha caiam sobre algo que parece feito à mão. Tiramos o amarelo da paleta pela mesma lógica que o app roda: a pequena deriva que você não percebe é a que leva tudo, quietinha."
