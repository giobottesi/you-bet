# Dia 10 — Afiando o portão de review

**Data**: 2026-07-05
**Fase do sprint**: Build-out do frontend (meio do sprint, dia 11 de 17 dias corridos)
**Planejado**: FE 02 — a próxima fatia de frontend

## TL;DR

- Dia gasto na meta-camada em vez de features: endurecemos toda a stack de review do contribuidor — `/write-review`, um novo gate `/sure-bet` de definition-of-done, e plugamos o `/write-review` dentro do `/my-bet`.
- Entregamos um ganho de DX pequeno — `git-delta` como pager do git, documentado num novo `docs/DEV_TOOLING.md` (PR #44) — pra que os diffs deste repo cheio de prosa parem de parecer raspadinha.
- Amadurecemos o sistema de memória: pegamos dois conflitos vivos entre skill e memória e codificamos a regra que impede eles de voltarem.
- FE 02 escorregou um dia de propósito. As ferramentas que protegem a qualidade eram o que fazia mais sentido consertar primeiro.

---

## O que foi feito

### O portão de review ganhou dentes

A stack de skills do contribuidor saiu de "checklist bacana" pra uma barra de fato. O `/write-review` — o passe de qualidade de prosa — foi endurecido: remoção de links-âncora mortos, detecção de deriva de terminologia, um passo real de privacidade/vazamento, e um fix pra ele parar de marcar a própria assinatura da betina como link morto. Um novo skill `/sure-bet` agora é o gate único de definition-of-done, orquestrando testes, lint, `/safe-bet`, `/write-review` e higiene de PR num passe só que o contribuidor roda antes de abrir qualquer coisa. E o `/write-review` agora está plugado *dentro* do `/my-bet`, então todo devlog passa pela mesma barra de prosa automaticamente, e não mais na base da confiança. O passe inteiro foi entregue como PR #40 (mergeado).

### Diffs melhores, barato

`git diff` é ruído num repo onde metade das mudanças é prosa. Instalei o `git-delta` e configurei como pager global — diffs com syntax highlight, nível de palavra, navegáveis. Em vez de deixar como conhecimento tribal, foi pra um novo `docs/DEV_TOOLING.md` como primeira entrada de um doc de tooling do contribuidor, entregue como PR #44. É só pager, então scripts e CI caem no diff plano sem serem afetados.

### O sistema de memória parou de mentir pra si mesmo

A vitória silenciosa do dia. Dois conflitos vivos apareceram onde a memória tinha copiado os internals de um skill e depois derivado: uma assinatura da betina desatualizada, e uma contagem de passos do `/safe-bet` que não batia mais com o skill real. Causa-raiz nomeada e codificada — memória guarda o *porquê* e a decisão; o arquivo do skill continua a fonte única da verdade pro *como*. Cópias derivam; ponteiros não. Esse único princípio aposenta uma classe inteira de bugs recorrentes.

---

## Decisões & mudanças

- **FE 02 adiado um dia pra endurecer o tooling primeiro.**
  - Por quê — os skills de review são o que mantém todo PR futuro na barra do time. Pagar essa dívida agora se acumula a favor em cada dia restante do sprint; fazer depois de FE 02 significaria FE 02 sem o gate.
- **Docs de tooling ganham casa própria (`docs/DEV_TOOLING.md`), na própria branch a partir de main.**
  - Por quê — dicas de DX não têm relação com o trabalho de feature em andamento; misturar numa branch de feature viola a higiene de PR pequeno que o projeto segue.
- **Memória para de espelhar internals de skill.**
  - Por quê — dois conflitos entregaram comportamento errado porque uma cópia de memória dos passos de um skill ficou velha. Aponte pra fonte da verdade em vez de duplicá-la.

---

## Contribuições do Gio

**Dia de direção: nenhuma feature entregue, e esse era o ponto — o Gio gastou as calls na maquinaria que faz toda feature futura sair mais limpa.**

**Escopo & sequenciamento**
- Chamou o adiamento do FE 02 — endureceu o portão de review *antes* da próxima feature, não depois. → *Todo PR restante agora passa por uma barra de qualidade imposta, não mais só esperançosa.*
- Escopou a nota do delta no próprio PR a partir de main em vez de pendurar na branch de hardening. → *Manteve o diff só de docs e o histórico da branch honesto.*

**Julgamento**
- Puxou por diffs *visuais* melhores justamente porque o repo é cheio de prosa — conectou uma escolha de tooling ao formato real do trabalho. → *`git-delta` escolhido pro loop de review, não por novidade.*
- Confiou no instinto de que o sistema de memória estava "conflitando coisa" — e estava. → *Trouxe à tona duas derivas vivas e as virou uma regra durável.*
- Insistiu que os rituais de betina/leveza são estruturais, não decoração. → *A brincadeira fica no sistema como ferramenta deliberada, não como excesso a cortar.*

## Saúde do sprint

**No trilho?** Sim
Um dia de investimento em processo no meio do sprint; a trilha de FE está uma fatia atrás, mas a infra de qualidade está agora à frente.

**Planejado vs real**: Planejado FE 02; na prática endureci os skills de review + entreguei o tooling do delta + amadureci o sistema de memória. Uma troca deliberada, não um atraso.

## Amanhã

- Pegar o **FE 02** — a fatia de frontend adiada — agora passando pelo gate `/sure-bet` endurecido.
- Backlog pra priorizar (parkado): generalizar a seção "contribuições do contribuidor" pra além do Gio, e aninhar os devlogs em diretórios por contribuidor.

---

_Custo de IA hoje: $38.23, 35.6M tokens (só you-bet)._

> **Betina diz:** "Construí um portão, um linter e um jeito mais bonito de olhar pros meus próprios erros. Amanhã eu erro de novo, mas em alta resolução."
