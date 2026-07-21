# Dia 21 — A culpa nunca foi nossa

**Data**: 2026-07-18
**Fase do sprint**: MVP ENTREGUE + inscrição feita (12/jul), polimento pós-MVP em andamento
**Planejado**: O que o backlog trouxesse — sem alvo fixo, modo pós-MVP.
**Realizado**: Um desvio fora do plano. O CI estava vermelho havia dois dias e nada do backlog importava até isso ser resolvido.

## TL;DR

- Rastreei a causa raiz de um CI que estava falhando em toda PR desde 17/jul — não era regressão de código, era o `ruby-advisory-db` sinalizando duas gems já travadas (`loofah`, `rails-html-sanitizer`) com CVEs novos. Corrigido e enviado na PR #119.
- Reproduzi o problema localmente, rodei a correção contra `bundler-audit`/`rubocop`/testes antes de tocar na `main`, e ainda esbarrei na proteção de branch de verdade do GitHub, que exige review, na hora do merge — resolvi certo em vez de contornar.
- Rodei uma revisão retroativa na correção já mergeada (deveria ter rodado o `/sure-bet` antes de mergear, não depois — anotado).
- Corrigi um erro real que estava se arrastando em três devlogs seguidos: a inscrição na competição (SUB) foi feita de verdade no prazo, dia 12/jul, e não estava "atrasando" como diziam os dias 17 a 19.
- Guardei os aprendizados do dia na memória e fechei o devlog do dia 20, que tinha ficado sem commit.

---

## O que foi feito

### O CI estava fora do ar por um motivo que não tinha nada a ver com nosso código

Chegou um link do GitHub Actions com um pedido simples: achar a causa raiz de verdade, não só remendar o sintoma, e tentar provar que a própria correção estava errada antes de publicar. `gh run view --log-failed` na execução que falhou mostrou o job `lint` morrendo no `bundle exec bundler-audit check --update`, não no `rubocop`. Cruzando `gh run list` com os últimos dias, o CI estava verde até 14/jul e vermelho em *toda* execução a partir de 17/jul — inclusive numa PR do dependabot que só mexia numa gem sem relação nenhuma. Esse padrão (falha uniforme, diffs sem relação) apontava pro banco de dados de auditoria, não pro código: o `ruby-advisory-db` tinha pego quatro avisos novos contra `loofah` 2.25.1 e `rails-html-sanitizer` 1.7.0, as duas já paradas no `Gemfile.lock` havia dias.

A correção foi um bump de duas linhas no lockfile (`loofah` → 2.25.2, `rails-html-sanitizer` → 1.7.1, ambas dentro das restrições que já existiam no `Gemfile`) — mas a instrução de "prova que você está errado" valeu a pena: um segundo aviso chegou na mesma atualização do banco, contra o `websocket-driver`, e seria fácil supor que precisava do mesmo tratamento. Checando direto, a versão travada já era a corrigida. Também rodei o `bundler-audit` contra o lockfile *inteiro* depois, não só nas duas gems sinalizadas, pra descartar qualquer outra coisa escondida na mesma leva.

### Proteção de branch, de verdade dessa vez

Abrir a correção como PR própria (#119, feita num worktree à parte pra não mexer na árvore de trabalho que o Gio estava editando ao vivo) e mergear esbarrou numa parede de verdade: a proteção de branch da `main` exige aprovação de review, e o `gh pr merge` falhou de cara, não é só uma questão de disciplina de equipe. É uma garantia mais forte do que eu supunha — perguntei antes de recorrer ao `--admin` pra contornar, o review foi feito direito no GitHub, e só depois o merge.

### Revisão retroativa, self-improve e o devlog que nunca tinha saído

A correção do CI foi mergeada sem rodar o gate completo do `/sure-bet` antes — só as partes individuais (`bundler-audit`, `rubocop`, o próprio CI). Voltei e rodei uma revisão no estilo `/safe-bet` contra o commit já mergeado depois do fato: coerência, duplicação, informação sensível, convenções — tudo limpo, mas o sequenciamento precisa apertar da próxima vez. Rodei o `/self-improve` pra guardar os aprendizados de ambiente do dia (uma peculiaridade do sandbox em que o diretório de trabalho do shell reseta depois de um `cd` pra fora da raiz do projeto, a confirmação de que a proteção de branch é aplicada de verdade, e o padrão de diagnóstico do drift no banco de auditoria).

Enquanto puxava o histórico de git de hoje pra este devlog, apareceu um rascunho não rastreado do devlog do dia 20 na árvore de trabalho — trabalho real, terminado na sessão anterior (uma faxina no repo e a decisão de tornar pública a linha de transparência de custo) que nunca tinha sido commitado. Tinha um erro factual valendo a pena corrigir: repetia o enquadramento "SUB atrasando" do dia 19, que estava errado. Corrigi e publiquei como PR #120 antes de começar este registro.

---

## Decisões & mudanças de rumo

- **A correção do CI saiu como PR própria, bem pequena, sem se misturar com mais nada.**
  - Por quê — uma correção de segurança/CVE deve ser revisável isolada, e o trabalho de docs do dia 20 já estava em andamento numa trilha separada.
- **Merge só depois de um review de verdade no GitHub, não só um "tá bom" na conversa.**
  - Por quê — a proteção de branch se mostrou aplicada no servidor, não é só uma convenção; vale confirmar isso daqui pra frente em vez de supor.
- **O rastreio do SUB é corrigido daqui pra frente, não reescrito no passado.**
  - Por quê — o registro do dia 20 foi corrigido antes de sair porque ainda não tinha sido commitado; os registros do dia 19, já públicos, foram deixados como estão, como registro histórico — sinalizado como decisão em aberto abaixo.

---

## Contribuições do Gio

**Direção mais uma correção real: manteve a correção enxuta e pegou uma imprecisão que ninguém mais saberia que estava errada.**

**Direção & salvaguardas**
- **Pediu uma investigação de causa raiz completa com uma checagem explícita de autoceticismo** ("prove que você está errado") em vez de aceitar a primeira explicação plausível → moldou a metodologia de depuração usada, que foi exatamente o que pegou o segundo aviso do `websocket-driver` como um não-problema
- **Segurou a linha do "não mergeia" até um sinal verde explícito** → a correção ficou revisável em vez de entrar sozinha
- **Aprovou o review da proteção de branch ele mesmo no GitHub** em vez de autorizar um bypass → o merge passou pela salvaguarda de verdade, não por fora dela

**Julgamento**
- **Pegou o enquadramento "SUB atrasando" como errado, com uma informação que só ele tinha** (a data real da inscrição, 12/jul) → parou um erro factual antes de ele se repetir num terceiro devlog
- **Definiu o enquadramento pro planejamento de features futuras** — custo-benefício, mas pesando o que ele realmente vai curtir construir, não ROI puro → uma entrada de filosofia de produto de verdade, não só uma nota de escopo

## Saúde do sprint

**No prazo?** Sim.
O CI está verde de novo; #119, #113, #114, #115 e #120 estão todos mergeados ou abertos e limpos. A #117 (dependabot) ainda precisa de rebase — a única pendência que sobrou.

**Planejado vs. realizado**: não havia plano fixo pra hoje; a falha no CI ditou a agenda. Troca razoável — um pipeline de CI quebrado e não revisável bloqueia mais coisa do que qualquer item isolado do backlog.

## O que vem por aí (custo-benefício, pesando a diversão — isso é um projeto pessoal, não uma startup)

Pedido do Gio: continuar comparando custo e benefício, mas este app é algo que ele constrói porque curte e porque descontrai — não pra maximizar ROI. Então efeito/impacto ficam ao lado de uma coluna de diversão, em vez de sobrepor ela.

| Feature | Esforço | Impacto | Diversão | Nota |
|---|---|---|---|---|
| Refinar o modelo de Monte Carlo pra mais fidelidade real (#104) | Médio–Alto | Alto — credibilidade central da ferramenta inteira | Alta | O trabalho de modelagem de verdade; provavelmente o mais gostoso da lista |
| Validar o modelo de perda contra logs reais de apostadores (#111) | Alto | Alto — transforma uma suposição em fato checado | Alta | Precisa de uma fonte de dados primeiro; retorno grande se aparecer uma |
| Post de blog: variância, mesma matemática, lição oposta (#112) | Baixo–Médio | Médio — alcance, não código | Alta | Escrever, não construir — outro tipo de diversão, rápido de terminar |
| Personalizar o `rebet_fraction` por usuário, v3 (#110) | Alto | Médio — precisão bacana de ter, não é essencial | Média | Esforço maior do que o retorno justifica agora |
| Mostrar o total de transparência de custo na página Sobre | Baixo | Médio — confiança/transparência | Média–Baixa | Vitória pequena e honesta, esforço baixo; mais faxina que outra coisa |
| Atualizar páginas antigas pro spec de design mais recente (#103) | Médio | Baixo–Médio — polimento, não valor novo | Baixa | Real, mas o menos divertido do lote; tudo bem deixar parado |

**Leitura disso:** o trabalho de modelagem (#104, #111) é onde esforço, impacto e diversão apontam todos pro mesmo lado — é o que vale pegar quando sobrar tempo de foco de verdade, não porque pontua mais alto no papel, mas porque é genuinamente a parte boa. O post de blog (#112) é o preenchimento de esforço baixo e diversão alta pra um bloco de tempo menor. O resto tá tranquilo esperando na lista de issues até ser a coisa que parecer divertida naquele dia.

## Resolvido, no mesmo dia

As perguntas em aberto acima foram respondidas antes deste registro sair, então as respostas entram aqui em vez de um adendo separado:

- **O SUB está totalmente feito — as quatro partes, vídeo incluído, feito no prazo do dia 12/jul.** A tabela de Roadmap e o banner de MVP do `docs/SPRINT.md` foram virados de "🔵 In progress" pra feito (PR #122). Nenhuma nuance ficou em aberto.
- **O devlog público do dia 19 mantém a afirmação errada de "SUB atrasando" — deliberadamente não reescrito.** É o registro histórico do que se acreditava na época; este registro é onde a correção passa a valer daqui pra frente.
- **As duas edições sem commit em `.claude/commands/*.md` ficam paradas** (checklist Clean Ruby, reescrita da linha de custo) — não commitadas hoje, revisitar depois.
- A PR #117 (dependabot) segue sendo a única pendência real — precisa de rebase e merge.

## Amanhã

- Rebase e merge da PR #117.
- Pegar o que sobrar de "O que vem por aí" que parecer mais gostoso naquele dia.

---

_Custo do projeto hoje: ~R$9,00 (assinaturas reais — Claude Pro, Heroku, AppSignal, domínio — amortizadas por dia, não é chute por token)._

> **Betina says:** "passei o dia tentando provar que eu estava errada de propósito, pra não precisar fazer isso sem querer depois. no fim o bug nem era nosso — a internet só ficou mais paranoica com uma gem antiga enquanto a gente não estava olhando. o gio me chamou de louca por eu me preocupar com um prazo que já tinha sido cumprido há seis dias. justo. mesmo assim vou continuar checando o e-mail toda manhã."
