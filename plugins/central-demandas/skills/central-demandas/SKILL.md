# Central de Demandas — AmFi

## Quando usar
Use esta skill sempre que o usuário pedir para gerar, atualizar ou abrir a Central de Demandas. Também deve disparar quando o usuário disser "gera minhas tarefas", "o que tenho pra fazer", "cria meu painel de demandas" ou variações.

## O que esta skill faz
Lê os e-mails, arquivos do Drive e agenda do usuário, extrai tarefas com IA e gera um artefato ao vivo personalizado chamado "Central de Demandas". O artefato fica salvo no Cowork e se atualiza automaticamente toda vez que o usuário abre.

## Execução — siga exatamente esta ordem

### PASSO 1 — Coletar e-mails importantes (Gmail)
Use `search_threads` do Gmail com as queries abaixo e colete os resultados:
- `is:starred` — e-mails estrelados (alta prioridade)
- `is:unread is:important newer_than:7d` — não lidos e importantes da última semana
- `is:unread newer_than:3d` — não lidos dos últimos 3 dias

Para cada thread relevante, use `get_thread` para ler o corpo completo. Foque em e-mails que contenham pedidos, prazos, ações requeridas ou decisões pendentes. Ignore newsletters, notificações automáticas e threads de CC sem ação requerida.

### PASSO 2 — Coletar arquivos do Drive
Use `search_files` do Google Drive para buscar:
- Arquivos modificados nas últimas 48h: `modifiedTime > '{ontem}' and mimeType != 'application/vnd.google-apps.folder'`
- Transcrições ou anotações de reuniões: `fullText contains 'transcrição' or fullText contains 'anotações' or fullText contains 'reunião'` com `modifiedTime > '{7 dias atrás}'`

Para arquivos relevantes, use `read_file_content` para extrair o conteúdo.

### PASSO 3 — Coletar agenda (Google Calendar)
Use `list_events` com janela de -3 dias a +14 dias para identificar:
- Reuniões que já aconteceram (potencial para tarefas de follow-up)
- Reuniões futuras (potencial para tarefas de preparação)

### PASSO 4 — Extrair tarefas com IA
Com todo o conteúdo coletado, analise e extraia tarefas seguindo estas regras:

**Classificação de urgência:**
- 🔴 **Urgente/Hoje**: prazo explícito para hoje, ou remetente é C-level/diretoria, ou e-mail tem "urgente"/"ASAP"
- 🟡 **Esta semana**: prazo mencionado dentro de 7 dias, ou e-mail de stakeholder importante sem prazo
- ⚪ **Próximas semanas**: sem prazo definido, ou prazo acima de 7 dias
- 🟣 **Follow-up de reunião**: ação mencionada em transcrição ou anotação de reunião realizada

**Para cada tarefa extraída, defina:**
- `id`: slug único (ex: `task-email-paulo-20260524`)
- `título`: ação concreta em uma linha (ex: "Responder Paulo sobre proposta Bradesco")
- `descrição`: contexto em 1-2 linhas
- `urgência`: uma das categorias acima
- `fonte`: "email", "drive" ou "reunião"
- `remetente/contexto`: quem enviou ou de onde veio
- `prazo`: data se explícita, senão "esta semana" ou "a definir"
- `keywords`: 3-5 palavras para cruzar com o Calendar
- `briefing`: objeto com campos `objetivo`, `pontos` (array), `contexto`, `sucesso`

### PASSO 5 — Gerar o artefato ao vivo
Use `mcp__cowork__create_artifact` com o HTML completo gerado a partir das tarefas extraídas.

O HTML deve seguir exatamente o design system da AmFi:
- Fonte: Montserrat
- Cor principal: `#E91E8C` (magenta AmFi)
- Background: `#f5f6fa`
- Cards com borda esquerda colorida por urgência (vermelho/amarelo/cinza/magenta)
- Header com título "Central de Demandas — [Nome do usuário]"

O artefato deve incluir:
1. **Stats bar**: contadores de Urgente/Hoje, Esta Semana, Concluídas, Total
2. **Barra de progresso** geral
3. **Status de agenda**: cruza tasks com Calendar via `mcp__2bcf1cbe-23ad-4d23-8641-4b2f88e18a8b__list_events`
4. **Seções de tasks** por urgência, cada card com checkbox, nome clicável, descrição, badges e data
5. **Drawer de briefing**: abre ao clicar no nome da task, mostra objetivo, pontos-chave, contexto e critério de sucesso
6. **Botão "Verificar Drive"**: busca novos arquivos e analisa com `window.cowork.askClaude`
7. **Análise de transcrições**: para tasks com reunião "Realizado" no Calendar, busca transcrição no Drive e analisa automaticamente

O artefato usa `window.cowork.callMcpTool()` para todas as chamadas de API e `window.cowork.askClaude()` para análises de IA. Estado de conclusão dos cards é persistido em `localStorage`.

**MCP tools que o artefato vai chamar:**
- `mcp__2bcf1cbe-23ad-4d23-8641-4b2f88e18a8b__list_events` (Calendar)
- `mcp__bcb42dce-c7a0-48b7-8882-bb75b9c52fe9__search_files` (Drive)
- `mcp__bcb42dce-c7a0-48b7-8882-bb75b9c52fe9__read_file_content` (Drive)

### PASSO 6 — Confirmar e orientar
Após criar o artefato, informe o usuário:
- Quantas tarefas foram extraídas e de quais fontes
- Que o painel fica salvo no Cowork e se atualiza toda vez que abre
- Que pode rodar a skill novamente a qualquer momento para atualizar as tarefas

## Notas importantes
- Nunca inclua tarefas hardcoded — tudo deve vir dos dados reais do usuário
- Se o usuário não tiver Gmail/Drive/Calendar conectados, explique quais conectores são necessários e como conectar
- O artefato gerado deve usar os IDs reais dos MCP tools disponíveis na sessão do usuário
- A identidade visual (cores, fonte, layout) deve seguir sempre o padrão AmFi descrito acima
- Se já existe um artefato `central-demandas` para o usuário, use `mcp__cowork__update_artifact` para atualizar em vez de criar um novo
