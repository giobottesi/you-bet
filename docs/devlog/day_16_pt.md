# Dia 16 — Fim de semana de entrega

**Data**: 2026-07-12
**Fase do sprint**: Página de Resultados + Páginas de Conteúdo + Polimento → Submissão (semana do prazo)
**Planejado**: Fechar os PRs de conteúdo pendentes, construir a página de resultados de verdade, deixar cada superfície pública pronta pra enviar.

## TL;DR

- Zerei toda a fila pendente: privacidade, `/place-bet`, a revisão de copy multi-modelo, `/ghost-bet` e o pre-commit por arquivo staged — tudo mergeado.
- Empurrão do dia do prazo: `/sources` ganhou o redesign em estilo caderno, a página Sobre finalmente foi pro ar, e a página de resultados ganhou cards de custo de oportunidade, uma chance de vitória honesta e uma seção de ajuda retrátil.
- O mesmo bug de build do Tailwind mordeu pela terceira vez — um formatter recolocando espaços dentro de `rgba()` num utilitário `shadow-[…]` aborta o build do CSS silenciosamente. Resolvido na raiz com CSS vars, fora do alcance de qualquer formatter.
- Reconferi cada número citado contra as fontes primárias de novo e derrubei dois que a gente não conseguia sustentar.
- A página de resultados lê mole demais pra quem cai nela sem contexto — parquei o redesign de UX pra uma sessão nova em vez de fazer pela metade às 2 da manhã.

---

## O que foi feito

### A fila pendente, esvaziada

Sábado fechou o backlog de revisão. A página de privacidade LGPD (#68) foi mergeada depois de uma reescrita em linguagem simples — o rascunho com voz de advogado deu lugar a "a gente" e a uma metáfora de chapelaria pro cookie, porque uma página de privacidade que ninguém lê não protege ninguém. A skill de descrição de PR `/place-bet` (#75), a passada de copy multi-modelo com 32 agentes em todos os docs estáticos (#78), a skill de escrita de copy `/ghost-bet` que ela virou (#79) e o escopo por arquivo staged no pre-commit (#80) — tudo entrou. Cinco PRs, zero drama.

### `/sources` vira um artefato de papel

A página de fontes largou os cards chapados pelo estilo caderno — barras de encadernação em kraft com cor alternada, corpos pautados com o texto travado nas linhas, um pôster de metodologia com folha erguida e sombra dura, e uma textura de papel reciclado assada uma vez num data-URI e misturada em cada superfície (#71). Depois as sete descrições dos cards de fonte foram localizadas pro pt-BR pela primeira rodada real de `/ghost-bet` (#82) — o merger pegou um rascunho que inflava "cerca de 3x" pra "3x mais" (~4x), exatamente o tipo de desvio de número que a skill existe pra impedir.

### A página de resultados cresce

Os cards de custo de oportunidade agora mostram o que o dinheiro perdido poderia ter sido — compras concretas mais um herói de poupança (#84, depois FE-07). A página também mostra a chance de vitória de curto prazo honesta em vez de esconder, e os recursos de ajuda viraram uma seção sempre visível e retrátil, no estilo de papel mas com a graça no talo — é a copy mais delicada do site. O controller degrada com elegância: se a taxa de poupança não estiver seedada, a seção bônus só some, nunca dá 404 no resultado principal.

### A página Sobre, segunda tentativa

Sobre foi pro ar (#83) — mas só depois de um desvio. Foi auto-mergeada como #76 sem revisão, revertida do main e reaberta pra um olhar decente. História, o mascote Gatinho, a declaração de uso de IA, a nota de naming, um card de logo, links e um FAQ da Betina pro Gio. O Gio escreveu a voz dele; o scaffold e o design foram o assist.

### A bomba do build, desarmada de vez

Um formatter fica recolocando espaços dentro de `rgba(0, 0, 0, 0.25)` quando ele mora num utilitário `shadow-[…]` do Tailwind. O Tailwind v4 não consegue parsear o token quebrado por espaço, então `tailwindcss:build` aborta, envia CSS velho e o design inteiro desmonta em silêncio. Terceira vez que mordeu. Fix de raiz: mover a cor pra CSS vars `--shadow-25/28/30` e referenciar `var(--shadow-25)` no utilitário — sem vírgulas, sem espaços, nada pro formatter tocar. O build em produção no main já estava quebrado por isso, então também levou um hotfix direto lá.

---

## Decisões & mudanças

- **Nunca fazer self-merge, aprendido no susto.** Sobre foi pra fila de auto-merge; o Gio pegou, voltou do main e reabriu pra revisão.
  - Por quê — uma entrada de competição pública não é mergeada pela estagiária. O revisor é o humano.
- **Citação repete a fonte, nunca a nossa conta.** Reconferi cada número contra as fontes primárias; derrubei um "+500% em 3 anos" sem fonte e um "66,8%" que a gente não achou.
  - Por quê — arredondamento que inverte uma desigualdade, ou um número que a gente mesma derivou, é invenção numa página cujo ponto inteiro é honestidade.
- **Parquei o redesign de UX dos resultados em vez de fazer pela metade.** A página lê mole demais pra quem chega frio de um link compartilhado.
  - Por quê — precisa do input em cima, de uma proporção perda-vs-apostado num relance e de um layout de painel, não de um remendo às 2 da manhã.

---

## Contribuições do Gio

**Fim de semana de direção: ele guiou cada superfície pública e matou o único merge que não devia ter acontecido.**

**Produto & escopo**
- Reenquadrou a página de resultados em torno de quem chega frio — "essa página é o resumo *e* o porquê de você estar vendo isso."
  - → *virou um despejo de dados num brief de redesign com um POV claro*
- Chamou o "30% ganhou e nada mais dá vibe errada" na copy da chance de vitória.
  - → *forçou o enquadramento honesto-mas-não-enganoso no número de destaque*

**Julgamento & checagem de fatos**
- Conferiu os números citados e sinalizou os sem fonte primária.
  - → *dois números não verificáveis derrubados antes de irem pro ar*
- Segurou a autoria da copy: "spell check, não coerência — meu texto."
  - → *manteve a página Sobre na voz real dele, não numa reescrita*

**Sequenciamento & execução**
- Pegou o self-merge e reverteu; definiu a ordem de merge da pilha pendente.
  - → *integridade de revisão mantida num repo público sob pressão de prazo*
- Deu autonomia total no trabalho mecânico e parqueou o redesign pesado pra contexto novo.
  - → *nenhuma tecla desperdiçada numa tarefa que precisava de cabeça fresca*

## Saúde do sprint

**No trilho?** Sim
**Planejado vs real**: Cada card de conteúdo e polimento está mergeado ou construído; o único item aberto é o redesign de UX dos resultados, adiado de propósito. Submissão é o passo que falta.

## Amanhã

- Redesign de UX da página de resultados: input em cima, proporção perda-vs-apostado num relance, layout de painel em vez de blobs de informação.
- Mergear #85 (leva o fix de raiz do build pro main) → #86 share.
- Verificar os números reais de preço do custo de oportunidade, depois gravar a demo e submeter.

---

_Custo de IA nesse trecho: $334,47, 497,9M tokens (só you-bet) — o fim de semana de orquestração multi-modelo._

> **Betina diz:** "Passei o fim de semana ensinando um site a dizer 'você vai perder esse dinheiro' em três fontes e dois idiomas. Os apps de aposta passaram o mesmo tempo ensinando o contrário em uma só. Estamos em menor número, mas nossa matemática é real."
