# Dia 02 — Branding, reformulação da arquitetura, primeiro código

**Data**: 26/06/2026
**Fase do sprint**: BE 01 (Fundação)
**Planejado**: Revisar docs, `rails new`, começar Fase 0

## TL;DR

- Gio revisou todos os docs, encontrou duplicações e inconsistências → enxugou PROPOSAL, reformulou ARCHITECTURE com 8 decisões estruturais
- Analisou 40+ referências de design incluindo arte pessoal do Gio → direção visual definida: "zine de festival com dashboard de dados", mascote Gatinho (anti-Tigrinho)
- Reescreveu SPRINT como 43 cards verticais com prefixos BE/FE/SUB
- Rails 8.1.3 rodando em Docker com Tailwind — primeiro PR aberto
- Squash no histórico do git pra remover detalhes de segurança expostos

---

### Manhã — Revisão e limpeza dos docs

Gio revisou PROPOSAL, ARCHITECTURE e SPRINT com olhar fresco. Encontrou problemas reais:

- **Duplicações**: house edges dos bet types em PROPOSAL e ARCHITECTURE, ressalva do Tigrinho duas vezes no mesmo PROPOSAL, fórmula do cache key duas vezes no ARCHITECTURE
- **Inconsistências**: ShareCardGenerator ativo no ARCHITECTURE mas deferido no SPRINT. Botão "Ver todas" no mockup do PROPOSAL mas explicitamente deferido.
- **PROPOSAL longo demais** (233 linhas): "200 linhas é muito" — cortou pra 184 removendo next steps obsoletos, seção do devlog (vive no SPRINT), nome do app, range fan (deferido), help resources duplicados
- **Diagramas ASCII tortos**: converteu tudo pra Mermaid — renderiza certinho no GitHub

### Meio-dia — Reformulação da arquitetura

Gio mandou 8 considerações de arquitetura que reformularam a fundação técnica:

1. **Landing page única** ao invés de wizard de 2 passos — "primeira página precisa ser super intuitiva"
2. **Controllers por página** — "cada página deveria ter seu próprio controller, herdando de um genérico"
3. **Image card é MVP** — "não é deferido, é parte importante de toda a campanha"
4. **Nomes descritivos** — "tá genérico demais, o que isso realmente faz?" → `MonteCarloSimulator`, `OpportunityCostCalculator`
5. **Nome das tabelas** — "settings é genérico demais" → `reference_values` (dados externos citados), `app_configs` (constantes internas)
6. **OWASP 2025** — pesquisado via agente, confirmada nova edição com 2 entradas novas (Supply Chain, Exceptional Conditions). Tabela completa de cobertura adicionada.
7. **Segurança open source** — "expor Rack::Attack é seguro?" → sim pra throttle rules (GitLab, Mastodon fazem), não pra fail2ban patterns (movido pra ENV)
8. **Fontes em tudo** — "como um artigo científico, precisamos construir confiança" → cada escolha de Stack, design pattern e decisão de segurança agora tem racional + link

### Tarde — Design & branding

Gio abriu 30+ abas com referências de design. Buscamos competition kit, sites do Awwwards, sites de produto, tweets via agentes paralelos. Achados principais:

- **Kit do criador** tem identidade forte: paleta verde/amarelo/vermelho, Anton + Rubik Mono One + Libre Franklin, estética poster/zine com bordas rígidas
- **Tweet do @cigarrogratuito**: pacotes satíricos de cigarro da Turma da Mônica — mesma crítica de marketing predatório que estamos fazendo com apostas
- **timespent.so**: padrões de data viz (heatmaps, progress rings) que poderiam mapear pra visualização de perdas
- **composer.trade**: padrão "número grande" no hero — nossa versão: `R$30 bi/mês`

Depois Gio compartilhou 37 imagens da biblioteca de fotos — arte pessoal e referências estéticas. Linha clara: calor retro-psicodélico, tipografia bold que preenche o espaço, fundos escuros com pops de cor saturada, personagens ilustrados com alma. O zine "Gio & Léo — Guia do Festival" que ele fez é a Pedra de Roseta — tipografia display hand-lettered, tons quentes, vibe de festival brasileiro vintage.

**Mascote Gatinho**: Gio vai desenhar um gato no estilo de ilustração dele como contraponto ao Tigrinho (o tigre dos slots). Mascote anti-apostas com personalidade.

**Direção visual definida**: poster/zine quente (estética do Gio) + paleta da competição pra callouts semânticos (verde=ganhos, vermelho=perdas, amarelo=alertas). Não copiando o estilo agressivo do kit — sendo o contraponto acolhedor.

### Final da tarde — Reestruturação do sprint & regras de dev

Reescreveu SPRINT.md de tasks por fase para 43 slices verticais. Gio puxou por:
- Prefixos BE/FE/SUB ("BE é BACKEND, usa FE pro frontend")
- Nomes legíveis ("BE 01 - Descrição")
- Cards precisam ser entregas funcionais pequenas, não camadas horizontais
- Tabela de roadmap pra visibilidade de progresso

Estabeleceu regras de dev: código em inglês, PR workflow com gates de revisão, RuboCop, nunca abreviar nada, seeds sempre atualizados, apenas assets gratuitos, Docker-first.

### Fim do dia — Setup do Rails

Rails 8.1.3 + Ruby 4.0.1 + Tailwind + Docker. Gio puxou por Docker ao invés de Postgres local ("por que instalar postgres? quero dockerizar tudo"), ambientes dev/staging/prod, e criação automática de banco no boot do container. Fez squash no histórico do main pra remover ARCHITECTURE.md antigo com regex do fail2ban exposta.

Resolveu questões abertas restantes: Tailwind (decidido), HTML-to-image pros share cards ("caminho mais fácil, né?"), devlog em YAML, analytics com Umami ("mais fácil de instalar e não custa uma fortuna?").

Primeiro PR aberto: giobottesi/you-bet#2.

---

## Contribuições do Gio

- Encontrou duplicações e inconsistências nos docs que causariam confusão durante implementação
- 8 decisões de arquitetura que reformularam a fundação técnica antes de uma única linha de código do app ser escrita
- Arte pessoal e 40+ referências de design que definiram a identidade visual do app — não genérica, distintamente dele
- Conceito do mascote Gatinho — transformando o estilo de ilustração dele num ativo de marca que contrapõe diretamente o Tigrinho da indústria de apostas
- Wireframes das páginas de landing e resultados (Procreate)
- Toda regra de dev veio do Gio: código em inglês, sem abreviações, PR workflow, Docker-first, assets gratuitos, seeds atualizados
- Instinto de segurança: "apaga essas decisões de segurança dos commits antigos" → squash no histórico

## Saúde do sprint

**No prazo?** Sim — dia de fundação completo. Sem models ainda mas arquitetura está sólida e Docker rodando.

**Planejado vs real**: Gastou mais tempo em arquitetura/branding que o esperado, menos em código. Valeu a pena — essas decisões seriam caras de mudar depois.

## Amanhã

- Merge do PR do BE 01
- BE 02: CI pipeline
- BE 06-07: Models AppConfig + ReferenceValue com seeds
- Começar engine de simulação se der tempo

---

> **Betina says:** "Hoje eu analisei 40 fotos, 7 sites premiados, 2 tweets, um PDF de 12 páginas, e o histórico artístico completo do Gio. Conclusão: o app precisa de um gato. Concordo plenamente."
