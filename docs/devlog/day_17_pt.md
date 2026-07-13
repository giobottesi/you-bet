# Dia 17 — No ar, e depois varrido

**Data**: 2026-07-13
**Fase do sprint**: MVP ENTREGUE (12/jul) — falta: SUB (demo, declaração de IA, registrar + enviar)
**Planejado**: Lançar o MVP no dia do prazo e fechar o ciclo.

## TL;DR

- **O You-Bet foi ao ar** — no ar em `youbet.gio.show`, anunciado no Instagram com um vídeo de lançamento.
- **O Gio escreveu a legenda de lançamento inteira, letra por letra** — o rascunho da IA foi descartado por parecer GPT.
- Empacotamos um vídeo de lançamento 9:16 legendado (transcript do Fireflies → burn-in com ffmpeg) e botamos no feed.
- Depois, um **ritual de faxina** — *defumar a casa*: varredura de compliance, 70+ branches velhas podadas, backlog organizado, README ganhou um futuro.
- Só falta o **SUB**. O build está pronto.

---

## O que foi feito

### A casa foi ao ar

O fluxo principal já estava entregável há um dia; hoje ele ficou *público*. URL no ar anunciada, post no Instagram sob a `#DesafioContraBets`, README ligado ao repo e ao post. A coisa existe no mundo agora.

### O conteúdo de lançamento — do Gio, na mão

A legenda que subiu no Instagram foi escrita **inteira pelo Gio, letra por letra**. Um rascunho da IA existiu por um instante e foi jogado fora por parecer modelo de linguagem; o post que subiu é a voz dele, a mão dele — "vc confia no gatinho? 🍀". No empacotamento: o transcript do vídeo veio do Fireflies e as legendas foram gravadas com ffmpeg depois de um re-sync. O conteúdo foi pro ar — é isso que importa.

### Defumar a casa — o ritual de limpeza

Com a pressão embora, o repo ganhou uma defumada. Uma varredura completa de compliance confirmou que nenhum dado pessoal ou sensível entrou no histórico público, e o vídeo de lançamento de 22MB está fora do alcance do git. Depois o cemitério de branches — **70+ branches mergeadas e velhas** deletadas, quatro stashes mortos limpos, worktrees sobrando removidas, origin podada até só as branches que ainda importam. `main` sincronizada e limpa.

### Um futuro que vale a leitura

A lista dispersa de "algum dia" foi organizada num backlog pós-MVP de verdade (#92), e o README ganhou uma seção **✨ Próximas iterações** — Monte Carlo mais afiado, mais formatos de compartilhamento, arte de custo no mundo real, um cantinho *pague um refri pro dev*, e tarefas do tamanho de contribuidor. O título da página Sobre também largou a formalidade: *Sobre* → *Projeto*.

---

## Decisões & mudanças

- **Os commits de lançamento foram direto pra main.**
  - Por quê — crunch de prazo; a cerimônia de PR foi suspensa pro polimento final e retomada pra tudo depois.
- **Tech-debt-como-issues foi organizado, não criado automaticamente.**
  - Por quê — abrir uma dúzia de issues públicas sem supervisão vai contra o hábito de não-ticketing do projeto; ficou parqueado como decisão.

---

## Contribuições do Gio

**Dia de lançamento: o código estava quase pronto — o julgamento era tudo.**

**Produto & voz**
- **Escreveu a legenda de lançamento inteira na mão, letra por letra** → *jogou fora o rascunho GPT-chapado da IA; o post que subiu é 100% as palavras dele*
- **Manteve a copy de lançamento numa atribuição explícita humano-vs-Betina** → *a declaração de IA lê como crédito honesto, não um vago "feito com IA"*

**Direção & julgamento**
- **Chamou o ritual de faxina inteiro — "defumar a casa"** → *um projeto entregue ganhou um histórico público limpo e auditável em vez de um pântano de branches*
- **Despejou a lista de trabalho futuro e conduziu a triagem de privacidade** → *features foram pro backlog público; fios pessoais e sensíveis ficaram fora do git*
- **Enquadrou o You-Bet como um primeiro passo, não uma linha de chegada** → *define a direção: simulação séria mirando problemas de interesse público*

## Saúde do sprint

**No caminho?** Sim — entregue.
O fluxo principal foi ao ar de ponta a ponta e está no ar; o único trabalho restante é a submissão.

**Planejado vs real**: Planejado lançar no dia do prazo — feito. Tudo depois do lançamento foi limpeza e fechamento, adiantado em relação ao passo do SUB.

## Amanhã

- **SUB** — gravar a demo, finalizar a declaração de IA, registrar e enviar.
- Nada mais bloqueia. Descansar primeiro.

---

_Custo de IA hoje: $338.60 · 501M tokens (só you-bet, dia 17 — a partir do Gio acordar meio-dia; o gasto da madrugada do dia 16 está lá)._

> **Betina diz:** "17 dias pra provar que a casa sempre ganha, e a última coisa que fizemos foi varrer a nossa. tem uma piada aí sobre limpar a bagunça de um projeto sobre não fazer bagunça, mas o gatinho já foi dormir. 🐱🍀"
