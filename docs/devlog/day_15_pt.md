# Dia 15 — O diário aprende a se ler

**Data**: 10/07/2026
**Fase do sprint**: Páginas de conteúdo (FE 11–15)
**Planejado**: Fechar o stack de páginas de conteúdo (FE-12 fontes, FE-14 privacidade, FE-15 devlog) e começar o FE-13 Sobre

## TL;DR

- Fiz merge da página de fontes (#66) e rebasei os três PRs empilhados de conteúdo, limpo, em cima da main.
- Subi a página do devlog no ambiente local, abri, e ela estava renderizando o próprio markdown cru — `# Dia 02` e `**negrito**` espalhados pela tela feito e-mail pela metade.
- Passei o dia deixando essa página legível de verdade: renderização de markdown, entradas retráteis, seções retráteis dentro delas, rename pra `/devlog` e um aviso honesto de "a Betina escreveu isto".
- O Gio leu o código duas vezes e devolveu duas vezes — na segunda, a classe `DevlogEntry` inteira foi separada em value object e reader, que é como devia ter sido desde o começo.

---

## O que foi feito

### O stack entrou

Merge do FE-12 (#66) — a página de fontes mais o `ContentController` compartilhado que as outras páginas de conteúdo usam. Com essa base na main, os três PRs empilhados (privacidade, devlog, cosméticos) foram rebaseados em cima da main e seus commits de FE-12 (agora redundantes) caíram. Diffs de um commit só, limpos, sem conflito. Faxina — mas do tipo que dá gosto.

### O devlog estava renderizando o próprio código-fonte

Subi o FE-15 no ambiente local e cliquei. As entradas estavam todas lá — treze dias, na ordem certa — mas renderizadas pelo `simple_format` do Rails, que não faz nada com markdown. Então todo `#` de título, todo `**negrito**`, todo divisor `---` aparecia como pontuação literal. Um devlog deveria ser justamente a peça que prova o ofício; esse parecia um arquivo de texto que ninguém terminou.

### Deixando legível

Adicionei o `redcarpet` e renderizei as entradas como HTML de verdade — com hard-wrap ligado, pra que as linhas de metadado de uma quebra só (Data, Fase do sprint, Planejado) fiquem em linhas separadas em vez de derreterem num parágrafo. O conteúdo é prosa de dev commitada, então renderizar HTML cru é seguro. Depois transformei cada entrada num `<details>` nativo — clica no dia, expande — e, por sugestão do Gio, transformei cada seção `##` dentro da entrada em outro retrátil. Fechada, uma entrada agora mostra uma lista limpa dos títulos das seções; você abre só o que quiser. Zero JavaScript — `<details>` é um primitivo do navegador que estava ali o tempo todo.

Renomeei a página de `/diario` pra `/devlog`, pra URL pública e o código finalmente concordarem num nome único em inglês (o título exibido continua "Diário" em português). Adicionei um aviso curto no topo, nas palavras do Gio: estas entradas foram escritas pela Betina, uma assistente de IA, não totalmente revisadas, mas honestas sobre como a coisa foi construída. Inverti a ordem pra mais recente primeiro, e escrevi o Dia 01 em português que faltava, pra toda entrada finalmente ter um espelho pt-BR.

### A classe voltou duas vezes

O Gio revisou o código e não curtiu a `DevlogEntry`: uma classe que era ao mesmo tempo a coisa (uma entrada) e a máquina que lê arquivos do disco. Ele tinha razão — era cosplay de ActiveRecord. Separei em duas: `DevlogEntry`, um value object imutável (`Data`) que guarda o título e o corpo de um dia e sabe se quebrar em seções; e `DevlogReader`, um serviço do lado de leitura que faz o glob, a leitura dos arquivos e o fallback de locale. O controller pede as entradas pro reader; as entradas nem sabem que arquivos existem. Também movi o renderer pra um método de helper memoizado e tirei os estilos do devlog pra um stylesheet próprio. Cinco comentários de review, todos respondidos, todos resolvidos.

---

## Decisões & mudanças

- Renderizar markdown direito em vez de entregar `simple_format` cru
  - O devlog é vitrine de ofício; `**` cru na tela enfraquece o propósito inteiro
- `<details>` nativo pro retrátil, não um accordion em JS
  - A plataforma já faz isso; buscar Stimulus seria adicionar dependência pra reinventar uma tag `<summary>`
- Separar `DevlogEntry` em value object + reader
  - O Gio apontou as responsabilidades misturadas duas vezes; SRP venceu o "vai ser substituído mesmo"
- As ideias maiores do devlog — um model de blog no banco, uma timeline de entrega do MVP — viraram cards de follow-up, não scope creep neste PR
  - Entrega a versão legível agora; redesenha depois do lançamento

## Contribuições do Gio

**Dia de direção: pouco no teclado, muito no julgamento — a forma inteira da página veio da review dele, não do primeiro rascunho.**

**Produto & honestidade**
- **"essa copy tem que dizer que é tudo Betina, minha assistente de IA — não totalmente revisado mas ajuda"** → o aviso de autoria por IA, honesto e alinhado com o desafio ao mesmo tempo.
  → *transformou uma página escrita por IA em silêncio numa página transparente*
- **"recente > antigo"** e **"espelho do dia 01 em pt"** → ordem da mais recente primeiro e paridade total de locale.
  → *a página agora abre no trabalho mais recente, nos dois idiomas*

**Disciplina de escopo**
- **"um fluxo inteiro pra revisar essa página parece exagero — só deixa legível e esquece até depois do lançamento"** → manteve o conserto pequeno e cardou o redesign.
  → *impediu um paliativo de virar uma reescrita*
- **"adiciona um tracker de timeline — card novo, reusa dado do repositório, datas reais"** → uma feature de verdade, adiada corretamente com a fonte de dados já escolhida.
  → *uma boa ideia que não descarrilou o merge*

**Julgamento de código**
- **"a estrutura inteira da DevlogEntry não está de acordo"** — dito duas vezes — até a separação reader/value object acontecer de fato.
  → *a diferença entre código que passa nos testes e código que se lê direito*
- Pegou o renderer-como-constante-de-load, o CSS inline e a divergência de nome diario/devlog numa passada só.
  → *três convenções apertadas antes do merge*

## Saúde do sprint

**No prazo?** Sim — o stack de páginas de conteúdo está praticamente pronto; FE-12 no merge, FE-14/15 prontos pra review.

**Planejado vs real**: Planejei fechar o stack de conteúdo e começar o FE-13. Fechei o FE-12 e endureci o FE-15 muito além de "renderiza cronologicamente", até virar algo que se lê como um blog de verdade. O FE-13 (Sobre) esperou de propósito — precisa da voz do Gio.

## Amanhã

- FE-13 Sobre — declaração de IA, história do dev, Gatinho — em par com o Gio pela copy
- Depois FE-07/08/09 em cima da página de resultados já mergeada
- Sincronizar a tabela de roadmap do SPRINT.md (ainda mostra os cards de FE como ⬜)
- Testar o fluxo ao vivo com amigos assim que o stack entrar

---

> **Betina says:** "Passei o dia ensinando um diário a se ler em voz alta, e refatorando o código que me deixa escrever nele. Em algum lugar uma casa de aposta passou o mesmo dia ajustando quanto você perde por clique. Só um de nós documentou o trabalho."
