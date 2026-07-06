# Dia 10 — Afiando o portão de review

**Data**: 2026-07-05
**Fase do sprint**: Build-out do frontend (meio do sprint, dia 11 de 17 dias corridos)
**Planejado**: FE 02 — a próxima fatia de frontend

## TL;DR

- Dia gasto na meta-camada em vez de features: endurecemos toda a stack de review do contribuidor — `/write-review`, um novo gate `/sure-bet` de definition-of-done, e plugamos o `/write-review` dentro do `/my-bet`.
- Entregamos um ganho de DX pequeno — `git-delta` como pager do git, documentado num novo `docs/DEV_TOOLING.md` (PR #44) — pra que os diffs deste repo cheio de prosa parem de parecer raspadinha.
- Amadurecemos o sistema de memória: pegamos dois conflitos vivos entre skill e memória e codificamos a regra que impede eles de voltarem.
- Colocamos o novo portão no primeiro teste de verdade — varremos todos os PRs abertos sob as regras endurecidas. Todos em conformidade, zero correção. A barra segurou no contato.
- FE 02 escorregou um dia de propósito. As ferramentas que protegem a qualidade eram o que fazia mais sentido consertar primeiro.

---

## O que foi feito

### O portão de review ganhou dentes

A stack de skills do contribuidor saiu de "checklist bacana" pra uma barra de fato. O `/write-review` — o passe de qualidade de prosa — foi endurecido: remoção de links-âncora mortos, detecção de deriva de terminologia, um passo real de privacidade/vazamento, e um fix pra ele parar de marcar a própria assinatura da betina como link morto. Um novo skill `/sure-bet` agora é o gate único de definition-of-done, orquestrando testes, lint, `/safe-bet`, `/write-review` e higiene de PR num passe só que o contribuidor roda antes de abrir qualquer coisa. E o `/write-review` agora está plugado *dentro* do `/my-bet`, então todo devlog passa pela mesma barra de prosa automaticamente, e não mais na base da confiança. O passe inteiro foi entregue como PR #40 (mergeado).

### Diffs melhores, barato

`git diff` é ruído num repo onde metade das mudanças é prosa. Instalei o `git-delta` e configurei como pager global — diffs com syntax highlight, nível de palavra, navegáveis. Em vez de deixar como conhecimento tribal, foi pra um novo `docs/DEV_TOOLING.md` como primeira entrada de um doc de tooling do contribuidor, entregue como PR #44. É só pager, então scripts e CI caem no diff plano sem serem afetados.

### O sistema de memória parou de mentir pra si mesmo

A vitória silenciosa do dia. Dois conflitos vivos apareceram onde a memória tinha copiado os internals de um skill e depois derivado: uma assinatura da betina desatualizada, e uma contagem de passos do `/safe-bet` que não batia mais com o skill real. Causa-raiz nomeada e codificada — memória guarda o *porquê* e a decisão; o arquivo do skill continua a fonte única da verdade pro *como*. Cópias derivam; ponteiros não. Esse único princípio aposenta uma classe inteira de bugs recorrentes.

### O portão passou no próprio primeiro teste

Uma barra de qualidade que ninguém rodou em trabalho real é uma hipótese. Então, no momento em que as regras foram mergeadas, elas foram apontadas pro conjunto aberto ao vivo: todo PR aberto — os de prosa (devlogs, a série de reflexões) e os dois PRs de código de FE (#37 re-skin, #38 landing) — varridos contra a barra endurecida do `/write-review` e `/sure-bet`. Resultado: todos em conformidade, zero correção, zero force-push. Os PRs escritos *depois* do hardening se conformaram sozinhos; pros dois que vieram antes, o único vazamento real que apareceu — um nome de terceiro na prosa do dia 09 — já tinha sido trocado por um neutro "outro app" durante a limpeza daquele dia. Aí saiu uma faxina de brinde: apaguei a branch de hardening agora redundante (os commits já tinham entrado no main via squash, então era duplicata) e podei as refs de rastreamento remoto obsoletas. O portão não só existia — ele segurou.

---

## Decisões & mudanças

- **FE 02 adiado um dia pra endurecer o tooling primeiro.**
  - Por quê — os skills de review são o que mantém todo PR futuro na barra do time. Pagar essa dívida agora se acumula a favor em cada dia restante do sprint; fazer depois de FE 02 significaria FE 02 sem o gate.
- **Docs de tooling ganham casa própria (`docs/DEV_TOOLING.md`), na própria branch a partir de main.**
  - Por quê — dicas de DX não têm relação com o trabalho de feature em andamento; misturar numa branch de feature viola a higiene de PR pequeno que o projeto segue.
- **Memória para de espelhar internals de skill.**
  - Por quê — dois conflitos entregaram comportamento errado porque uma cópia de memória dos passos de um skill ficou velha. Aponte pra fonte da verdade em vez de duplicá-la.
- **Validar o portão contra os PRs ao vivo no dia em que ele merga, não depois.**
  - Por quê — uma barra que nunca rodou em trabalho real não está provada. Varrer o conjunto aberto inteiro na hora transformou "deve segurar" em "segura" e não achou nada pra corrigir — o sinal mais forte possível de que o hardening era real.

---

## Contribuições do Gio

**Dia de direção: nenhuma feature entregue, e esse era o ponto — o Gio gastou as calls na maquinaria que faz toda feature futura sair mais limpa.**

**Escopo & sequenciamento**
- Chamou o adiamento do FE 02 — endureceu o portão de review *antes* da próxima feature, não depois. → *Todo PR restante agora passa por uma barra de qualidade imposta, não mais só esperançosa.*
- Escopou a nota do delta no próprio PR a partir de main em vez de pendurar na branch de hardening. → *Manteve o diff só de docs e o histórico da branch honesto.*
- Chamou a varredura de PRs no momento em que as regras mergaram — validar o portão no conjunto aberto ao vivo, e aí limpar a branch morta. → *Confirmou que todo o conjunto aberto passa na nova barra sem retrabalho; o hardening foi provado, não presumido.*

**Julgamento**
- Puxou por diffs *visuais* melhores justamente porque o repo é cheio de prosa — conectou uma escolha de tooling ao formato real do trabalho. → *`git-delta` escolhido pro loop de review, não por novidade.*
- Confiou no instinto de que o sistema de memória estava "conflitando coisa" — e estava. → *Trouxe à tona duas derivas vivas e as virou uma regra durável.*
- Insistiu que os rituais de betina/leveza são estruturais, não decoração. → *A brincadeira fica no sistema como ferramenta deliberada, não como excesso a cortar.*

## Saúde do sprint

**No trilho?** Sim
Um dia de investimento em processo no meio do sprint; a trilha de FE está uma fatia atrás, mas a infra de qualidade está agora à frente.

**Planejado vs real**: Planejado FE 02; na prática endureci os skills de review + entreguei o tooling do delta + amadureci o sistema de memória + varri o conjunto de PRs abertos deixando tudo em conformidade com a nova barra. Uma troca deliberada, não um atraso.

## Amanhã

- Pegar o **FE 02** — a fatia de frontend adiada — agora passando pelo gate `/sure-bet` endurecido.
- Backlog pra priorizar (parkado): generalizar a seção "contribuições do contribuidor" pra além do Gio, e aninhar os devlogs em diretórios por contribuidor.

---

_Custo de IA hoje: $41.58, 38.8M tokens (só you-bet)._

> **Betina diz:** "Construí um portão, um linter e um jeito mais bonito de olhar pros meus próprios erros. Amanhã eu erro de novo, mas em alta resolução."

---

## Apêndice — o plantão pelo celular de domingo

Escrito depois dos fatos; a coisa toda aconteceu pelo celular, no meio de um domingo, bem na hora em que o Brasil perdeu o jogo da Copa e caiu — timing irônico pra uma sessão de debug que insistia em terminar do mesmo jeito: a casa ganha nas primeiras tentativas.

`youbet.gio.show` voltou do primeiro deploy no domínio próprio como um 500 contínuo. O que parecia de cara um problema de DNS ou certificado do Heroku virou dois bugs reais e independentes, só visíveis depois que o caminho de deploy de verdade rodou de verdade, em vez de só ser teorizado:

- **O banco nunca foi migrado.** Não existia fase de release nenhuma, e depois que uma foi criada, o add-on único de Postgres do Heroku não suportava os três bancos separados (`solid_cache`/`solid_queue`/`solid_cable`) que o app tinha configurado. Juntar tudo no banco principal ainda não bastou — a checagem "esse banco já existe" do `db:prepare` fazia com que as tabelas nunca fossem criadas de fato, então toda requisição que tocava os contadores de throttle do `Rack::Attack` (que usam o cache) dava 500.
- **O tailwind.css nunca entrava num único build.** Um segundo 500, sem relação com o primeiro (`Propshaft::MissingAssetError`), sobreviveu a duas tentativas de gambiarra via rake — limpar o cache de arquivos do Propshaft, depois chamar a CLI direto em pontos diferentes do grafo de tasks — antes da causa real aparecer: `app/assets/builds/.keep` nunca tinha sido commitado, então a pasta não existe ainda quando o Rails registra os caminhos de assets no boot, num checkout novo do Heroku. O Gio achou essa com uma busca simples no Google, mais rápido do que o loop de reprodução local estava conseguindo convergir.

Os dois foram resolvidos no PR #46, verificados de ponta a ponta contra uma instância real de Postgres e um checkout limpo de verdade — não só o estado da working tree — antes de serem dados como prontos. Rodar a suíte de testes de verdade como parte do `/sure-bet`, não só reprodução manual, pegou uma terceira regressão, mais discreta, que o próprio conserto tinha introduzido (o hook de carregar schema quebrando o `db:prepare` em test/dev), antes de chegar a virar PR.

**Contribuição do Gio nessa rodada:** conduziu cada virada do diagnóstico pelo celular — descartou DNS, rodou o primeiro `db:migrate` ele mesmo pelo console do Heroku, questionou a segurança da fase de release antes de deixar subir, e venceu duas rodadas de gambiarra em rake escritas por IA com uma busca no Google. Placar do dia: Brasil 0, house edge 2 (dois palpites errados antes do certo), Gio 1 (o conserto de verdade).

> **Betina diz:** "O Brasil caiu da Copa e meus dois primeiros consertos também caíram antes do intervalo. Pelo menos o app que eu tava debugando é o que avisa que a casa sempre ganha primeiro — só não esperava ser a demonstração de abertura da casa."
