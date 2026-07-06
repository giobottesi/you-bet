# Dia 11 — Sete versões de um slider

**Data**: 2026-07-06
**Fase do sprint**: Landing Page (cards de FE)
**Planejado**: FE 02 — seletor de tipo de aposta (carousel/slider, lê de `BetType`, controller Stimulus; todos os tipos renderizam, pelo menos um obrigatório)

## TL;DR

- FE-02 entregue e mergeado (#54): um **slider de checkboxes em papel**, multi-seleção, para os sete tipos de aposta.
- O seletor passou por umas sete versões visuais ao vivo — radios viraram checkboxes, uma barra de progresso virou setas viraram setas que vazam pra fora das bordas, os fades nas bordas entraram e saíram, um tooltip nasceu e foi enterrado.
- O i18n aconteceu **no caminho**, não depois — o seletor está todo localizado (en + pt-BR), strings e tudo.
- O controller Stimulus foi endurecido pra ficar idiomático: `ResizeObserver` no lugar de listener de window, targets no lugar de `querySelector`, nomes que dizem o que fazem.
- Dois furos do fluxo de review que o Gio apontou viraram convenções e foram mergeados à parte (#55).

---

## O que foi feito

### O seletor, versão por versão

O card pedia um "carousel/slider" lendo de `BetType`. O scaffold do #50 já existia — partial stub, controller stub, um slot no form — então a tarefa era preencher. Mas o dia foi mesmo no visual.

Partimos de um tratamento de radio em papel guardado no `DESIGN.md` (uma pen do Uiverse), reconstruímos na paleta do You-Bet com cantos retos e o grain travado, e dispusemos os sete tipos num carousel horizontal com scroll-snap e um acento rotacionando por card. Aí começou a iteração: os radios de seleção única viraram checkboxes multi-seleção; a affordance de scroll passou por uma barra de progresso, depois setas, depois setas que vazam pras bordas do slider pra ler como "tem mais coisa aqui"; os fades entraram, pareceram bug de renderização no último card, e saíram. Cada volta era um screenshot do Gio e um delta de uma linha de volta.

### i18n, não depois

No meio do caminho, a decisão: localizar enquanto constrói, pra sobrar menos dívida de tradução pra reconciliar depois. Toda string do seletor foi pra `simulations.bet_type_picker` (en + pt-BR) — título, dica, prefixo da vantagem da casa, aria-labels — incluindo o contador de seleção e a mensagem de validação no JS, que entram como `values` do Stimulus pra a copy ficar nos arquivos de locale. O que sobra (o hero do FE-01, ainda em inglês) ganhou seu próprio card de tech debt em vez de uma varredura pela metade.

### Deixando o controller Stimulus revisável

A observação do Gio no controller foi direta e justa: controller Stimulus é o pior de revisar. Então pesquisamos as convenções, checamos os fatos, e refizemos — o listener de `resize` na window virou um `ResizeObserver` no carousel (pega reflows que um evento de window perde), `sync` virou `updateArrows`, todo método ganhou um comentário de intenção de uma linha, e um `querySelector(".bet-card")` perdido virou um `card` target de verdade.

### Transformando notas de review em regras

Duas dessas lições não eram de um PR só. A descrição do PR tinha ficado desatualizada três vezes conforme a branch andava, e as correções de Stimulus são o tipo de coisa que você quer pegar toda vez. As duas viraram convenções — um passo de "re-sincronizar a descrição do PR com o diff final" no `/sure-bet`, e um bloco de Stimulus no `/safe-bet` (nomes de método idiomáticos de Rails, um trabalho cada, `ResizeObserver`, i18n via values, targets no lugar de DOM na mão) — na própria branch de docs, mergeadas como #55.

---

## Decisões & mudanças

- **Tipos de aposta multi-seleção, não único.**
  - Por quê — o Gio quer que a pessoa marque todo tipo de aposta que faz. Isso colide com um engine que recebe um `bet_type_key`; essa decisão ficou parada como nota local, não como ticket, já que é escopo de FE-05/BE.
- **Matamos a barra de progresso, os fades e o tooltip.**
  - Por quê — a barra ficou pesada, os fades pareceram bug, e o tooltip era morto no touch (o app é mobile-first). O peek mais as setas nas bordas já carregam a pista de scroll.
- **i18n no caminho.**
  - Por quê — menos carga de tradução depois. Localizar cada superfície conforme ela entra em vez de uma varredura adiada.
- **Lições de review codificadas, não só aplicadas.**
  - Por quê — um PR desatualizado e um controller Stimulus não-idiomático são recorrentes, não pontuais. Pertencem ao gate, na própria branch.

---

## Contribuições do Gio

**Dia de direção: design por screenshot, e duas das próprias notas de review dele viraram regra da casa.**

**Produto & escopo**
- **Deixou o seletor multi-seleção.** → *Trouxe à tona uma decisão real de engine (um `bet_type_key` vs vários) antes do FE-05 esbarrar nela às cegas.*
- **Chamou o i18n como algo do caminho, não uma fase.** → *Transformou uma varredura de tradução iminente em trabalho pequeno, por superfície.*

**Julgamento de design**
- **Rejeitou a barra de progresso e os fades, quis setas que vazam as bordas.** → *Chegou numa affordance de scroll que de fato lê como rolável.*
- **Pegou o tooltip como hostil ao mobile.** → *Matou um explicador só de hover que nunca dispararia no touch.*
- **Guiou as coisas pequenas** — linha de instrução vermelha, chevron que preenche a caixa, caixa de seta menor. → *O seletor parece intencional, não default.*

**Engenharia & processo**
- **Nomeou a dor de revisar Stimulus e puxou por nomes de método idiomáticos de Rails.** → *Um controller que diz o que faz, mais uma convenção reutilizável pro próximo.*
- **Pediu pra codificar o re-sync da descrição do PR e as regras de Stimulus.** → *Um review virou um padrão que todo contribuidor agora cumpre.*

## Saúde do sprint

**No trilho?** Sim
FE-02 está mergeado com testes, i18n e um controller endurecido; dois dos cinco cards de Landing Page agora estão prontos.

**Planejado vs real**: Planejamos FE-02, entregamos FE-02 — mais um desvio não planejado mas válido codificando as convenções de review que ele expôs.

## Amanhã

- FE-03 — input de valor semanal (radio cards nas âncoras do DataSenado + campo custom, validação em Stimulus).
- Levar os padrões de card em papel + Stimulus do FE-02 adiante; agora são o estilo da casa pra esses widgets.

---

_Custo de IA hoje: $49,96, 53.602.982 tokens (só you-bet)._

> **Betina diz:** "Sete versões de um botão de rolar. O tigrinho radicaliza a cabeça de alguém em milissegundos, e eu aqui debatendo se a setinha cabe na caixa. Mas é justo: se a gente vai dizer que a casa sempre ganha, o mínimo é que o botão pra descobrir isso seja bonito de doer."
