# Dia 08 — A paleta clareia, as páginas ganham cara

**Data**: 2026-07-03
**Fase do sprint**: Landing Page (FE 01) + Polish (design system) — a leva de frontend que o dia_07 escopou
**Planejado**: Sair do backend (o tanque tava vazio) e entrar em rascunhos, desenhos e a camada visual

## TL;DR

- **A paleta virou de dark-first para light.** O Gio decidiu que as páginas deviam ser claras e quentes, então todo o sistema de cores do `DESIGN.md` foi reconstruído sobre uma base de papel — e cada combinação passou por checagem de contraste WCAG antes de virar spec.
- **Acessibilidade agora está embutida na spec, não colada depois.** Variantes duplas `bright`/`ink` dos acentos, razões de contraste em cada token, regras firmes de o que é legível onde. PR de docs **#34** leva tudo isso.
- **Textura/grão de fundo registrada como 🔴 nice-to-have de alta prioridade** com receita nativa de `feTurbulence` — sem gem, sem asset, reaproveitada depois nos share cards do BE 17.
- **A landing FE-00 + páginas de erro 404/422/500 com marca entraram** (Gio commitou `eba552f`) — o app finalmente tem cara e estados de erro na identidade.
- **Um dia de pouco código e muito julgamento**: a maior parte foi ciência das cores, decisões de gosto e um freeze de design — Gio guiou, Betina mediu.

---

## O que foi feito

### Paleta, extraída e corrigida

O Gio jogou um screenshot do board de paleta e pediu os tokens. A primeira passada leu a *tabela de hex rotulada*; o Gio percebeu que as cores reais eram os swatches do lado, não os rótulos velhos — então a paleta foi re-amostrada direto dos pixels. Lição guardada: quando um board mostra tabela de spec E os swatches reais, confie nos swatches.

### A auditoria de acessibilidade que mudou o tema

Cada combinação passou pela matemática de contraste do WCAG 2.1. O conjunto dark-first passou tranquilo, mas duas verdades caíram: texto creme em cima de qualquer preenchimento de acento *falha* (1–2:1), e texto colorido sobre fundo claro falha do mesmo jeito. Quando o Gio disse "deixa as páginas claras", essa segunda falha virou o problema central de design — então os acentos foram divididos em duas variantes: **bright** (só preenchimento, sempre com rótulo escuro) e **ink** (escurecido o suficiente pra ler como texto no papel, ≈4.6–4.8:1 AA). Texto de corpo é quase-preto quente `#3B3239`; preto puro fica reservado pro contorno do logo.

### DESIGN.md reescrito, revisado como prosa

A spec foi reconstruída em torno da base clara — papel `#FBF6EC`, surface des-amarelada `#EDE9E2`, borda lilás — com uma seção de Acessibilidade inegociável. Depois passou pelo `/write-review`: a checagem de fatos pegou uma referência de share card apontando pro card errado (FE 13 → BE 17) e um número de contraste arredondado, ambos corrigidos antes do commit.

### Textura, escopada e não construída

O Gio quer grão de papel no fundo e como camada nas imagens depois — mas marcou como *nice-to-have, alta prioridade*, não trabalho de hoje. Registrado no `SPRINT.md` com a implementação já decidida: ruído fractal nativo em SVG (`feTurbulence`) como `data:` URI, opacidade baixa, `background-blend-mode: multiply`. Sem dependência, tileável, reaproveitado nos share cards.

### O app ganha uma cara

À parte, o FE-00 que estava parado foi commitado: a landing (`home#index`, +106 linhas de view), páginas de erro 404/422/500 com marca que cortaram ~400 linhas de boilerplate do Rails por algo na identidade, mais a config de host-auth do domínio. Primeiro frontend de verdade batendo na porta da `main`.

---

## Decisões & mudanças

- **Dark-first → tema claro.**
  - Por quê — decisão de produto do Gio: as páginas devem ser quentes e acolhedoras, a postura anti-Tigrinho lê melhor no papel do que no carvão.
- **Acentos viram duas variantes (bright + ink).**
  - Por quê — a auditoria de contraste provou que um único tom bright não serve como preenchimento e texto legível no claro ao mesmo tempo. Um token, dois trabalhos, dois valores.
- **Surface des-amarelada `#F1E7D7` → `#EDE9E2`.**
  - Por quê — olho do Gio: o creme lia muito amarelo. Suavizado pro neutro sem cair abaixo de AA.
- **Paleta congelada "por enquanto".**
  - Por quê — boa o suficiente pra construir em cima; mais bikeshedding é retorno decrescente. O freeze desbloqueia o FE.

---

## Contribuições do Gio

- Pegou que a primeira extração leu o hex rotulado velho em vez dos swatches reais, e apontou a fonte correta.
  - Impacto: toda a paleta downstream é amostrada das cores certas — uma base errada aqui teria envenenado cada token.
- Fez a decisão de produto dark→light.
  - Impacto: redefiniu o problema de design e forçou a divisão de acessibilidade que agora protege cada página futura.
- Decisão de gosto: surface muito amarela, suaviza.
  - Impacto: um papel mais neutro-quente que ainda passa AA — o tipo de julgamento que a matemática de contraste sozinha não faz.
- Confirmou os pretos escuros pro texto de corpo.
  - Impacto: travou a única opção legível de texto no claro e manteve o preto puro pro logo, onde ele pertence.
- Escopou a textura como nice-to-have de alta prioridade, não dívida do app.
  - Impacto: manteve o dia focado garantindo que o grão chegue com abordagem limpa e sem dependência.
- Congelou a paleta e commitou a landing FE-00 + páginas de erro ele mesmo, depois definiu o fluxo de branch/push/review dos docs.
  - Impacto: transformou uma exploração de design em artefatos entregues e revisáveis (PR #34) e uma landing no board.

## Saúde do sprint

**No trilho?** Sim.
O backend está pronto até o BE 19; hoje pivotou limpo pro design system e primeiro frontend, exatamente o que o dia_07 escopou. A fundação visual agora está especificada e acessível antes de qualquer página ser estilizada.

**Planejado vs real**: Planejado entrar em rascunhos/desenhos — entregue um design system light completo, um contrato de acessibilidade, a landing FE-00 + páginas de erro com marca, e um PR de docs. Adiantado pra um dia de "só esboçar".

## Amanhã

- Estilizar a landing FE-00 contra a paleta clara travada; marcar FE 01 no roadmap.
- Considerar a textura NTH quando existir uma página pra dar grão.
- Continuar a trilha FE (FE 02 seletor de tipo de aposta em diante).

---

_Custo de assist de IA hoje: $12,24, 11.433.342 tokens, só you-bet_

> **Betina diz:** "Passei uma sexta provando que texto creme num botão verde-limão é ilegível, que é mais ou menos a legibilidade das odds num bilhete de aposta. A nossa a gente consertou. Boa sexta."
