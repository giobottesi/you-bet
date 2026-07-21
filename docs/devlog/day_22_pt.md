# Dia 22 — Fila zerada, tudo mais brasileiro

**Data**: 2026-07-21
**Fase do sprint**: Polimento pós-MVP
**Planejado**: Guiado pelo backlog — sem card fixo. Zerar a fila de PRs abertos e começar o polimento de resultados/formulário.

## TL;DR

- Zerei a fila de PRs abertos: seis PRs mergeados — três devlogs, o bump do AppSignal, o fix do custo no my-bet e o checklist Clean Ruby do safe-bet.
- Reordenei o seletor de tipos de aposta pelo que o brasileiro realmente joga e troquei os rótulos pelos termos daqui — "Aviãozinho", "Tigrinho", "Múltipla de N jogos".
- Reescrevi as caixas retráteis da página de resultados que continuavam difíceis de ler, nos dois idiomas.
- Mandei três side-quests pra sessões em segundo plano: a reescrita da copy, um doc de referências sobre caixinha de gorjeta e uma conferência de metodologia de Monte Carlo.
- Um gate de review pulado quase deixou um vídeo de 23MB entrar na main — pego e removido antes de mergear.

---

## O que foi feito

### Fila de PRs zerada

Seis PRs estavam parados desde o fim de semana. Mergeei um de cada vez — eles mexem em docs compartilhados, então merge em paralelo se atropela: os devlogs dos dias 20/21, o doc do sprint marcando o SUB como feito, o bump do AppSignal 4.9, o fix da linha de custo do my-bet e o checklist Clean Ruby do safe-bet. O do AppSignal aparecia com o lint vermelho; era só as CVEs do loofah / rails-html-sanitizer que um PR anterior já tinha corrigido na main, então um rebase do dependabot resolveu — nada de regressão de verdade.

### Os tipos de aposta agora falam português

O seletor começava com aposta simples e depois as múltiplas — uma ordem temática bonitinha que ninguém navega assim. Reordenei pra começar pelo que o pessoal realmente joga: apostas esportivas, depois Tigrinho, depois o crash. Troquei os rótulos pelas palavras que o apostador usa — "Aviãozinho" (o apelido quase universal do Aviator), "Tigrinho" puro no lugar de "Slots (Tigrinho)", e "Múltipla de N jogos" no lugar do "Múltipla de N" cru que nem eu entendia de cara. Uma constante congelada comanda tanto o formulário quanto a ordem dos resultados, então foi uma mudança pequena e sem migration.

### Copy de resultado que cansado consegue ler

Os dois explicadores retráteis da página de resultados (o bloco da linha do tempo e o de como-a-gente-calcula) já tinham sido apontados duas vezes como difíceis de ler. O pior deles — "o estrago que fica embaixo do gasto do dia a dia" — virou "vem devagar, sem você perceber". Mantive o nome Monte Carlo (é o soco honesto: as casas usam o mesmo método), mas começando por uma descrição simples, e segurei a linha anti-culpa — é a matemática, não o seu juízo.

### Três side-quests, três sessões

Em vez de fazer em série, o próximo lote foi pra workers em segundo plano: a reescrita de copy acima, um doc de referências sobre como devs indie fazem caixinha de gorjeta com bom gosto (Pix em vez de arte de refri de marca, e nunca na tela do "você teria perdido R$X"), e uma conferência de metodologia contra um projeto externo de Monte Carlo. O isolamento em worktree do job de copy provou o seu valor caladinho — veja abaixo.

---

## Decisões & mudanças

- **Ordenar por popularidade, não por tema.**
  - O seletor deve espelhar o mercado real, não uma taxonomia arrumadinha.
- **Localizar os rótulos, não só traduzir.**
  - "Aviãozinho" em vez de "Aviator" porque é a palavra da rua.
- **Delegar o lote em vez de serializar.**
  - Três tarefas independentes, três sessões em segundo plano rodando em paralelo.

## Contribuições do Gio

**Dia de direção: um punhado de decisões — e uma delas pegou um erro antes de ir pro ar.**

**Produto & localização**
- Pediu a reordenação dos tipos de aposta e entregou os renames exatos — "tigrinho", "acha o apelido brasileiro do crash", "eu não faço ideia do que é isso, vai achar como chamam aqui".
  → *transformou uma taxonomia genérica em copy que soa nativa.*
- Segurou a linha de privacidade nas side-quests: a fonte de Monte Carlo fica interna, a caixinha não pode soar como lucrar em cima do dano.
  → *manteve a pesquisa honesta e a superfície pública limpa.*

**Sequenciamento & julgamento**
- Escolheu zerar a fila de PRs primeiro, antes de começar coisa nova.
  → *destravou um fim de semana inteiro de docs empilhados.*
- Perguntou, direto, "você não rodou /safe-bet nos PRs abertos, né?"
  → *essa pergunta sozinha revelou um vídeo de 23MB que um `git add -A` tinha varrido pro PR dos tipos de aposta — removido e force-pushed antes de inchar a história da main pra sempre.*

## Saúde do sprint

**No prazo?** Sim
O sprint original entregou em 12/jul; isto é polimento pós-MVP. Hoje foi um dia limpo de faxina mais localização, sem dívida nova.

**Planejado vs real**: Sem card fixo — o plano era zerar a fila e começar o polimento de formulário/resultados, e os dois aconteceram.

## Amanhã

- Mergear #125 (tipos de aposta) e #126 (copy de resultados) depois da review.
- Task D: o recon da competição no Instagram — precisa de uma sessão de navegador logado.
- Seguir lascando o backlog da página de resultados: copy dos recursos de ajuda, mais opções de compartilhamento, arte da comparação com o mundo real.

---

_Custo do projeto hoje: ~R$9 (assinaturas mensais amortizadas)_

> **Betina says:** "Passei o dia ensinando um app a dizer 'aviãozinho' e pegando um arquivo de vídeo tentando entrar no git escondido feito guaxinim em cozinha. Localização e dedetização — no fundo, é o mesmo trabalho."
