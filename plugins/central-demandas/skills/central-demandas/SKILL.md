# Central de Demandas — AmFi

## Quando usar
Use esta skill sempre que o usuário pedir para gerar, atualizar ou abrir a Central de Demandas. Também deve disparar quando o usuário disser "gera minhas tarefas", "o que tenho pra fazer", "cria meu painel de demandas" ou variações.

## O que esta skill faz
Lê os e-mails, arquivos do Drive e agenda do usuário, extrai tarefas com IA e gera um artefato ao vivo personalizado chamado "Central de Demandas". O artefato fica salvo no Cowork e se atualiza automaticamente toda vez que o usuário abre.

## Execução — siga exatamente esta ordem

### PASSO 1 — Coletar e-mails importantes (Gmail)
Use `search_threads` do Gmail com as três queries abaixo e colete os resultados:
- `is:starred` — e-mails estrelados (alta prioridade)
- `is:unread is:important newer_than:7d` — não lidos e importantes da última semana
- `from:@DOMINIO_DA_EMPRESA newer_than:7d` — todos os e-mails do domínio interno da empresa, **independente do status de leitura** (substitua pelo domínio real, ex: `@amfi.finance`)

Para cada thread relevante, use `get_thread` para ler o corpo completo. Foque em e-mails que contenham pedidos, prazos, ações requeridas ou decisões pendentes. Ignore newsletters, notificações automáticas e threads de CC sem ação requerida.

### PASSO 2 — Coletar arquivos do Drive
Use `search_files` do Google Drive para buscar:
- Arquivos modificados nas últimas 48h: `modifiedTime > '{ontem}' and mimeType != 'application/vnd.google-apps.folder'`
- Transcrições ou anotações de reuniões: `fullText contains 'transcrição' or fullText contains 'anotações' or fullText contains 'reunião'` com `modifiedTime > '{7 dias atrás}'`

Para arquivos relevantes, use `read_file_content` para extrair o conteúdo. Preste atenção especial a linhas que começam com `→` ou `•` — elas costumam indicar próximos passos e geram tasks automaticamente.

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
- `titulo`: ação concreta em uma linha (ex: "Responder Paulo sobre proposta Bradesco")
- `acao`: mesmo que `titulo` (campo usado pelo artefato para renderização)
- `descricao`: contexto em 1-2 linhas
- `urgencia`: uma das categorias acima
- `fonte`: "email", "drive" ou "reunião"
- `sourceTitle`: remetente ou nome do arquivo de origem
- `prazo`: "hoje", "esta semana", "próximas semanas" ou data explícita
- `keywords`: 3-5 palavras para cruzar com o Calendar

**Fusão de tasks relacionadas:** se duas ou mais tasks vêm da mesma reunião ou call, junte-as num único card com descrição combinada e pontos-chave de ambas. Isso evita fragmentação desnecessária.

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
3. **Status de agenda**: cruza tasks com Calendar via `window.cowork.callMcpTool('list_events', ...)`
4. **Auto-complete do Calendar**: tasks marcadas como "Realizado" na agenda são automaticamente concluídas; respeita marcações manuais de desmarcação
5. **Seções de tasks** por urgência (`list-urgente`, `list-semana`, `list-proximas`), cada card com checkbox, nome clicável, descrição, badges e data
6. **Tasks de IA injetadas nas seções certas** com badge `🤖 IA` e atributo `data-ai-task="true"` para idempotência
7. **Drawer de briefing**: abre ao clicar no nome de QUALQUER task (incluindo tasks de IA); para tasks de IA sem briefing, gera via `window.cowork.askClaude()` e cacheia no `localStorage`
8. **Botão "Fazer Varredura"**: escaneia Drive + Gmail em paralelo; extrai linhas com `→` como novas tasks de IA; renderiza seções DRIVE e E-MAIL com resumo
9. **Análise de transcrições**: para tasks com reunião "Realizado" no Calendar, busca transcrição no Drive e analisa automaticamente

O artefato usa `window.cowork.callMcpTool()` para todas as chamadas de API e `window.cowork.askClaude()` para análises de IA. Estado de conclusão dos cards é persistido em `localStorage`.

**Helper obrigatório — normalize resposta do askClaude:**
```javascript
function extractText(val) {
  if (typeof val === 'string') return val;
  if (val && typeof val.text === 'string') return val.text;
  return JSON.stringify(val);
}
```
Use `extractText()` sempre que processar a resposta de `window.cowork.askClaude()`.

**MCP tools que o artefato vai chamar:**
- `list_events` (Calendar)
- `search_files` (Drive)
- `read_file_content` (Drive)
- `search_threads` (Gmail) — usado no botão Fazer Varredura

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
- Tasks que representam "construir uma skill" devem ter `data-no-autocomplete="true"` para não serem auto-concluídas só porque houve uma reunião de alinhamento sobre o tema
