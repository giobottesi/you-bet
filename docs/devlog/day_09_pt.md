# Dia 09 — A spec vira pele

**Data**: 2026-07-04
**Fase do sprint**: Landing Page (FE 01) — a leva de frontend
**Planejado**: Repaginar as páginas placeholder do FE-00 para a paleta clara já travada, e começar o layout do FE-01

## TL;DR

- **A paleta de ontem saiu da spec e chegou nas páginas.** A landing e as três páginas de erro foram reconstruídas sobre a base de papel clara — e o contrato de acessibilidade bright/ink do dia 08 sobreviveu ao primeiro contato com markup de verdade.
- **O app ganhou o nome de verdade.** O Gio entregou a arte do logo, então o placeholder de texto "You-Bet" virou o wordmark real, verde e roxo, na landing e em toda página de erro.
- **O esqueleto do FE-01 está de pé**: `SimulationsController#new`, header/hero/form-shell/footer na paleta clara, request spec verde.
- **Duas branches, dois PRs (#37 repaginação, #38 FE-01)** — separados de propósito, pra que merges paralelos não se atropelem.
- **Um imposto de pegadinha foi pago e anotado**: dois buracos de ambiente de dev (env do rspec, colisão de porta com outro app da máquina) custaram tempo uma vez e não custam mais.

---

## O que foi feito

### A paleta sai da spec e chega nas páginas

O dia 08 travou a paleta clara no `DESIGN.md`, mas as páginas ao vivo ainda vestiam o tema escuro aposentado. Hoje esse buraco foi fechado. A landing e as páginas `404` / `422` / `500` foram reconstruídas sobre papel `#FBF6EC`, com texto ink e bordas lilás. A regra de variante dupla de ontem teve seu primeiro treino de verdade: os sparkles decorativos e o gato de ASCII agora usam as variantes **ink** pra continuarem legíveis no claro, enquanto os chips de "coming soon" e "back home" mantêm os preenchimentos **bright** com labels escuros. O contrato de acessibilidade foi escrito como prosa no dia 08 — hoje ele teve que se segurar como CSS de verdade. E se segurou.

### O app ganha o nome de verdade

A landing estava mostrando um wordmark de texto como quebra-galho. O Gio entregou a coisa real — dois SVGs feitos no Inkscape, um wordmark horizontal e uma marca quadrada empilhada, preenchimento verde com contorno roxo. O logo horizontal agora encabeça a landing e cada página de erro; a marca quadrada fica no header do FE-01. O gato de ASCII segue como placeholder do mascote até o Gatinho de verdade ser desenhado.

### FE-01, o esqueleto

O primeiro card real da landing. `SimulationsController#new`, uma rota e a casca do layout: header (menu, logo, Help), um hero WHAT/WHY, uma área de formulário com borda esperando os campos de tipo de aposta / valor / prazo que chegam no FE-02–04, links do site, e um footer de ajuda apontando pra CVV 188 e Jogadores Anônimos. A rota raiz continua sendo o placeholder "coming soon" por enquanto — não há motivo pra trocar uma página de espera limpa por um formulário que ainda não envia. Request spec verde: renderiza 200, contém o formulário.

### Duas branches, mantidas separadas

Repaginação e FE-01 foram em branches separadas por decisão do Gio, em PRs separados. Uma pequena armadilha desviada no caminho: as duas branches queriam um arquivo de logo em `public/`, o que teria dado conflito add/add em qualquer uma que fizesse merge por segundo. Dar nomes de arquivo distintos — `you-bet-logo.svg` e `you-bet-mark.svg` — deixa elas fazerem merge em qualquer ordem.

### O imposto da pegadinha

Dois buracos de ambiente custaram tempo e foram anotados nas notas de ops pra só custarem uma vez. Primeiro: `rspec` rodado via `docker exec` cai no env **development** do container, onde a config de host-authorization do dev bloqueia o host padrão de teste — 403s que parecem falha de verdade até você forçar `RAILS_ENV=test`. Segundo: `localhost:3000` nessa máquina já está ocupado por outro app, não o you-bet, então cada screenshot teve que ser renderizado **offline** a partir do HTML buscado no container. Chato uma vez, documentado pra sempre.

---

## Decisões & viradas

- **Repaginação e FE-01 como branches/PRs separados.**
  - Por quê — um card por PR; cada diff continua revisável e os merges continuam independentes.
- **Nomes de arquivo de logo distintos entre as duas branches.**
  - Por quê — evita um conflito add/add no caminho compartilhado `public/` quando a segunda branch faz merge.
- **A raiz continua sendo o placeholder do FE-00; o FE-01 vive em `/simulations/new`.**
  - Por quê — não colocar um formulário sem função no domínio ao vivo enquanto o "coming soon" ainda dá conta.
- **Hexes da paleta ficaram inline por view.**
  - Por quê — as páginas de erro precisam ser autossuficientes (renderizam quando o Rails cai), então um stylesheet `:root` compartilhado espera até um terceiro app view justificar. Sinalizado, não construído.

---

## Contribuições do Gio

- Fez merge dos PRs da paleta do dia 08 (#34) e do FE-00 (#35) antes da sessão.
  - Impacto: deu à repaginação de hoje uma paleta clara travada e uma landing page pra de fato repaginar.
- Entregou a arte real do logo — wordmark horizontal + marca quadrada.
  - Impacto: o app trocou um placeholder de texto por identidade de marca de verdade na landing e nas páginas de erro.
- Definiu a divisão em branches e cravou as regras (autonomia total, sem prompts, não fazer merge).
  - Impacto: uma corrida longa de build → review → PR → devlog rodou sem idas e vindas, e o histórico ficou limpo e revisável de forma independente.

## Saúde do sprint

**No prazo?** Sim.
A leva de frontend está andando — o FE-00 está totalmente na marca e o layout do FE-01 está de pé. A ciência de paleta do dia 08 agora está provada contra páginas reais, em vez de viver numa spec.

**Planejado vs real**: Planejado repaginar o FE-00 e começar o FE-01 — os dois feitos, mais a integração do logo e dois consertos de ambiente anotados.

## Amanhã

- **FE-02** — seletor de tipo de aposta (carrossel/slider lendo de `BetType`, primeiro controller Stimulus): o primeiro card interativo.
- Assim que #37/#38 fizerem merge, a área de formulário do FE-01 fica pronta pros primeiros campos reais.
- Consolidar a paleta num stylesheet `:root` compartilhado se um terceiro app view aparecer.

---

_Custo de assistência de IA hoje: $22.58, 23,1M tokens (só you-bet)._

> **Betina diz:** "Passei o dia dando cor pra uma página que existe pra dizer 'não aposta'. O cassino tem néon piscando; a gente tem papel, um gatinho de ASCII e contraste que passa no WCAG. Aposto que o papel dura mais — e essa é a única aposta segura da casa."
