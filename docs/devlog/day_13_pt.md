# Dia 13 — O formulário envia

**Data**: 2026-07-08
**Fase do sprint**: Frontend — a passagem do formulário para os resultados
**Planejado**: FE-05 envio do formulário (`#create` → rodar o simulador → persistir → redirecionar para um permalink de resultados)

## TL;DR

- FE-04 (slider de horizonte) mergeado como **#61** mais cedo hoje — o polimento de affordance de ontem entrou.
- FE-05 construído e enviado para review como **#63**: o formulário deixou de ser manequim. Ele envia, valida, persiste e redireciona para um permalink.
- Resolvido o bloqueio que o FE-04 revelou — **como uma simulação salva encontra seus resultados** — guardando os inputs na `Simulation` e deixando o `SimulationResult` como cache compartilhado puro.
- Adotado **permalink com UUID agora**, não depois, pra que os links de compartilhamento sejam não-sequenciais desde o primeiro save.
- Suíte cresceu de 106 → 120 verdes, `/sure-bet` limpo de ponta a ponta.

---

## O que foi feito

### FE-04 cruza a linha (#61)

O slider de horizonte mergeou mais cedo hoje depois de uma rodada de review. O trabalho de arrastabilidade de ontem — o glifo ↔ no thumb, o preenchimento de acento que acompanha o thumb, o alvo de toque de 44px, o `aria-valuetext` — tudo sobreviveu à leitura do Gio. Três comentários inline, cada um aplicado e respondido na thread: extração de helper pra que o template não faça lookup de constante, rotação de acento por slot, e agrupar os specs de constante sob um único `describe`. Quatro cards de frontend agora estão na `main`, com o FE-05 em review atrás deles.

### O bloqueio: uma simulação salva não tinha caminho de volta

O FE-04 deixou uma mina pro FE-05. Uma linha de `Simulation` guardava só um `visitor_id` — sem inputs, sem associação a nenhum resultado. O `SimulationResult` é um cache *compartilhado* read-through, chaveado pela assinatura dos inputs; não pertence a ninguém. E um envio de formulário se abre em leque: escolha três tipos de aposta, receba três linhas de cache. Então quando alguém abrir um permalink amanhã, o `#show` não tem nada pra reconstruir os resultados. As peças existiam; o fio entre elas não.

### Decidindo a ligação — Opção 1

Três jeitos de conectar uma simulação aos seus N resultados: guardar os inputs na `Simulation` e reler o cache a partir deles; uma tabela de junção listando quais linhas de cache pertencem a ela; ou copiar os números do resultado pra dentro da simulação como snapshot. Gio escolheu a Opção 1. O cache continua cache, a simulação lembra o que o usuário escolheu, e o `#show` re-deriva o resto. Sem tabela de junção, sem snapshot desnormalizado — uma coluna ganha de uma abstração, que é exatamente a arquitetura da casa.

### UUID agora, não no FE-06

No meio da decisão o Gio perguntou se a gente ia rastrear os permalinks por slug — e isso é um eixo *diferente* do armazenamento. O que vai na URL é uma pergunta; o que a linha guarda é outra. Em vez de deixar o FE-06 fazer uma migration de permalink depois, a gente adicionou uma coluna `uuid` agora e apontou o `to_param` pra ela. Os links de compartilhamento são opacos e não-sequenciais desde o primeiro dia; a primary key bigint sequencial fica interna. Uma migration a menos lá na frente.

### Construindo o `#create`

A action lê os params top-level do formulário, descarta a entrada de valor customizado em branco, carimba o `visitor_id` do cookie assinado, persiste a simulação, aquece uma linha de cache por tipo de aposta selecionado (buscando a margem da casa de cada tipo nos dados de referência) e redireciona pro permalink UUID. Input inválido re-renderiza o formulário com um `422`. O `#show` busca o registro por UUID e dá 404 se não achar, apoiado numa view stub propositalmente magra — a página de resultados de verdade é trabalho do FE-06, e dourar a pílula agora seria desperdício. Os specs de request e model entraram junto: envio válido, envio inválido, aquecimento de cache por tipo, carimbo de visitante, busca por permalink, 404. 120 exemplos, zero falhas.

---

## Decisões & mudanças

- **Ligação Opção 1.** A simulação guarda os próprios inputs; o `SimulationResult` continua cache compartilhado puro.
  - Por quê — tabela de junção e snapshot adicionam maquinário que o modelo cache-é-cache não precisa.
- **Permalink UUID adotado no FE-05, não no FE-06.**
  - Por quê — separar a pergunta de identidade-da-URL da pergunta de armazenamento mostrou que o UUID era barato agora e economizava uma migration depois.
- **`timeframe_weeks` persistido só como default de exibição.**
  - Por quê — o simulador já retorna os cinco horizontes por rodada, então o slider seleciona uma visão, não é input de simulação.

---

## Contribuições do Gio

**Dia de direção: três chamadas, cada uma tirou uma curva errada antes dela acontecer.**

**Julgamento / arquitetura**
- **Rejeitou as opções empacotadas e perguntou "não seria por slug que a gente rastreia os shows?"** — expôs que eu tinha misturado duas decisões independentes numa lista só.
  → *Forçou a separação limpa — identidade da URL vs. inputs guardados — que foi o que de fato destravou o design.*
- **"idk if its worth not using uuids rn"** — puxou a decisão do UUID pra frente.
  → *Links não-sequenciais desde o primeiro save, e uma migration a menos no prato do FE-06.*

**Escopo / execução**
- **"for the rest, simple route"** — segurou o `#show` num stub.
  → *Sem dourar uma view de resultados que o FE-06 reescreve; o diff continuou um PR enxuto de um card só.*

---

## Saúde do sprint

**No prazo?** Sim
Do FE-01 ao FE-05 está feito ou em review; o formulário é um produto funcional de ponta a ponta, com quatro dias pro deadline.

**Planejado vs real**: Planejado FE-05 envio do formulário — entregue, e ainda o FE-04 mergeado no mesmo dia. O único escopo que o card *cresceu* foi a decisão de ligação, que era pré-requisito, não desvio.

## Amanhã

- FE-06 — a página de resultados: renderizar as N linhas de cache por trás de um permalink, e mostrar um tipo de aposta cuja margem da casa está faltando em vez de exibir um vazio.
- Sincronizar a tabela de roadmap desatualizada do SPRINT.md (FE 01–05 ainda aparecem como não-iniciados).

---

_Custo de assistência de IA hoje: $22.33, 21.3M tokens, somente you-bet._

> **Betina diz:** "Construí um permalink pra galera compartilhar exatamente quanto uma aposta custa pra eles. Em algum lugar um growth PM tá rascunhando a mesma feature com o sinal trocado."
