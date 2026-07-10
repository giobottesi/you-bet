# Dia 14 — Dia de review, e o imposto que cobramos de nós mesmos

**Data**: 2026-07-09
**Fase do sprint**: Frontend — revisando o lote do parallel-worktree para o `main`
**Planejado**: Revisar + fazer merge do lote do Dia 13 (#63 → #66 → #67/#68/#69), aplicando o feedback pelo caminho

## TL;DR

- **Três PRs mergeados** — #63 (form FE-05), #67 (resultados FE-06) e #70, um PR de limpeza que só existe porque mergeamos o #67 cedo demais.
- **A página de fontes ganhou espinha dorsal**: cada número re-verificado contra a fonte *primária*, com deep-link para onde ele de fato aparece, e as notas metodológicas localizadas nos dois idiomas.
- **Uma "invenção" que não era**: "bets pesam 3x mais que os juros" parecia inventado — era real (coeficientes de regressão 0,2255 vs 0,0709). Outros dois números *estavam* errados (unidade, atribuição) e foram corrigidos.
- **Novo sistema de labels no GitHub** pra que um PR pela metade não seja confundido com pronto pra merge de novo.
- Cosméticos também entraram — washi tape e uma caixa tracejada (#71).

---

## O que foi feito

### #63 e #67 — revisar, aplicar, mergear

FE-05 e FE-06 entraram depois de uma rodada de review. O feedback do #63 foi pequeno e limpo: um callback `before_create` pro UUID no lugar de um método de instância chamado `create`, e os specs convertidos pro estilo nested-let. O #67 pediu pra mover a conta da perda do helper da view pra dentro do `SimulationResult` — um reader memoizado por horizonte.

### O merge prematuro, e o imposto

Aí o #67 foi mergeado — antes da rodada de *simplificação* que o Gio tinha pedido. A memoização e os guards defensivos de nil/zero estavam superdimensionados pro que os readers fazem (um horizonte simulado sempre aposta mais que zero, então os guards eram inalcançáveis). A versão limpa teve que voltar como um PR separado (#70): branch a partir do main, refazer, re-preview, re-gate. Trabalho que já estava escrito, pago duas vezes. Num app feito pra mostrar às pessoas o custo do "só mais uma", fizemos exatamente essa aposta.

### A página de fontes faz jus ao nome (#66)

A `/sources` é a página de credibilidade, então os números têm que estar certos. Não estavam, não totalmente. Uma checagem contra cada fonte primária achou desvios: "5 milhões de famílias" eram na verdade 5 milhões de *pessoas* em domicílios do Bolsa Família; o número de R$30 bi/mês estava atribuído ao Banco Central sendo que é da CNC; "53,9% mulheres" era do Procon-SP, não do DataSenado. Cada fonte agora carrega um **deep link** pro estudo exato — não a home — e um `url` no dado. As notas metodológicas (incluindo uma nova sinalizando que a magnitude da CNC é publicamente contestada) viraram chaves localizadas, então a página lê inteira em português. A tabela verificada mora no `docs/DATA.md` como registro durável.

### Cosméticos (#71)

Washi tape — fitas translúcidas presas sobre cada card via `::before`/`::after`, sem drop shadow, pra o card parecer colado no papel em vez de flutuando. As notas metodológicas ganharam uma caixa de borda tracejada. Stickers ainda estão na pilha do "vamos pensar".

## O Livro de Tokens — a eficiência pagou de fato?

O Gio fez uma pergunta justa no fim: nossa eficiência de tokens melhorou, medida contra o trabalho *de fato entregue* — não contra o quanto parecemos ocupados. Aqui está o livro do dia, ranqueado por odds. Num app anti-bets, é justo a gente se avaliar pela margem da casa que rodamos contra nossa própria janela de contexto.

- 🥇 **Melhor odd — delegar a auditoria das fontes.** ~53k tokens de pesquisa web, gastos inteiramente num subagente, devolvidos como tabela comprimida. Alto valor, custo isolado da thread principal. A aposta que paga.
- 🥈 **Os ajustes enxutos do #63.** Dois arquivos, ler-aplicar-shippar, sem thrash.
- 🥉 **Os moedores** — modo caveman, chamadas de tool em lote, um screenshot headless pra *verificar* a fita em vez de descrever. Pouco sozinhos; juntos, a diferença entre uma sessão que dura e uma que capota.
- 📉 **Pior odd — o merge prematuro do #67.** Um PR inteiro de follow-up pra terminar trabalho já escrito. O imposto, pago em cheio.
- 📉 **A parte da casa** — branches de preview resetados, worktrees re-auditados, CSS rebuildado mais de uma vez.

**O pagamento: misto, honestamente.** Delegação e disciplina compraram fôlego; o merge prematuro e o vai-e-vem de branches devolveram um pedaço. Shippamos pesado — mas a economia foi *reconquistada*, não guardada limpa. E a conta de IA do dia foi a mais alta do sprint, o que é a própria piada do livro.

---

## Decisões & mudanças

- **Uma taxonomia de labels de PR** (`do not merge` / `needs review` / `review applied` / `ready to merge` / `stacked: waiting` / `stacked: ready`).
  - Por quê — o #67 foi mergeado antes da hora; labels tornam o "pronto pra merge" explícito pra não acontecer sem querer.
- **Verificar contra a fonte primária, não o resumo; deep-link em cada número.**
  - Por quê — uma página de credibilidade não pode carregar um número que se perdeu no caminho. Links genéricos de domínio não bastam.
- **Cosméticos antecipados** de um follow-up pós-merge pra agora.
  - Por quê — o Gio quis ver a fita e iterar, não aprovar no escuro.

## Contribuições do Gio

**Dia de direção: uma dúzia de decisões, e as mais afiadas foram sobre no que *não* confiar.**

**Review & simplificação**
- **"muito overengineered — dá pra memoizar?"** → colapsou os readers do #67 em métodos pequenos; matou os guards inalcançáveis.
- **"passar params não é problema se deixa mais limpo"** → livrou o refactor de um value object desnecessário.

**Fluxo & sequenciamento**
- **Pegou o merge prematuro do #67 e chamou "branch com as correções, PR novo"** → conteve o dano como #70 em vez de um revert bagunçado.
- **Inventou a taxonomia de labels** → prontidão pra merge agora legível num olhar.

**Integridade dos dados**
- **"não quero números perdidos no contexto"** → disparou a auditoria completa contra fontes primárias que pegou os erros de unidade e atribuição.
- **Pegou o duplo sentido do Bolsa Família** e pediu um link explicativo neutro → preciso, e coerente sem editorializar.
- **"link genérico não serve — busca onde cada um disse o quê"** → deep links, não homes.
- **"todos os locales, por favor"** → notas localizadas, paridade mantida.

## Saúde do sprint

**No trilho?** Sim.
Três PRs mergeados, a página de fontes endurecida a um bar de verdade, cosméticos em review. O único arrasto foi autoinfligido (o re-merge), e agora virou correção de processo com label.

**Planejado vs real**: Planejei revisar + mergear o lote; fiz isso pro #63/#67, endureci o #66 bem além do escopo original, e adicionei um PR de cosméticos. #68/#69 seguem empilhados e esperando.

## Amanhã

- Mergear o #66, re-apontar #71/#68/#69 pro main, revisar o stack em ordem.
- Decidir a direção do sticker/carimbo (ou dar a fita como suficiente).
- FE-13 About — precisa da voz/copy do Gio, então é card pra fazer junto.

---

_Custo de IA hoje: $39,24, 37,9M tokens, só do you-bet._

> **Betina diz:** "A casa sempre ganha — acontece que até quando a casa é o seu próprio orçamento de tokens. Da próxima vez a gente saca antes do merge, não depois." 🎲
