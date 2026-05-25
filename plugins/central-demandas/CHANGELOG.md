# Changelog — Central de Demandas

## v1.7.0 (2026-05-24)
- **Fix Drive search para atas com `/` no assunto** — caracteres especiais como `/` (ex: "PLD/FT") eram enviados crus ao Drive API e quebravam a query; agora são removidos antes da busca
- **Keywords filtragem no Drive** — resultados do Drive filtrados por título relevante, evitando puxar docs genéricos (ex: Manual de Compliance em vez da ata específica)
- **Notion fallback para atas** — quando Drive não encontra a ata específica, busca automaticamente nas bases **Decisões** e **Reuniões - Otallin** do Notion e inclui o conteúdo encontrado no contexto da análise de e-mail
- **`modifiedTime` filter no Drive** — busca de ata limita a arquivos criados após 2026-05-01, evitando docs antigos

## v1.6.0 (2026-05-24)
- **Anti-duplicata** — tasks existentes injetadas no prompt dos 3 scanners (Drive/Email/Notion) para a IA não gerar tasks já cadastradas
- **Merge por similaridade** — `createAITasks` usa comparação fuzzy em vez de igualdade exata para reconhecer tasks reformuladas
- **Limpeza on-init** — duplicatas acumuladas no localStorage são removidas automaticamente na abertura
- **One-time clear** — AI tasks corrompidas/duplicadas apagadas de vez na próxima abertura

## v1.5.0 (2026-05-24)
- **Assunto do e-mail salvo nas AI tasks** — cada task gerada por e-mail guarda o assunto original para busca precisa ao verificar encerramento
- **Resolução de e-mail usa subject exato** — ao abrir drawer de task concluída, busca `subject:"..."` no Gmail em vez de keywords genéricas
- **Varredura inclui Notion** — botão "Fazer Varredura" agora escaneia Drive + E-mail + Notion (Reuniões - Otallin) e exibe resultados em três seções
- **Encerramento inteligente** — seção do drawer detecta automaticamente se a task foi encerrada via e-mail, reunião ou manualmente; título e conteúdo se adaptam ao contexto

## v1.4.0 (2026-05-24)
- **Badge AmFi / Externa** — tasks geradas pela varredura de e-mails agora indicam a origem: badge verde "🏢 AmFi" para remetentes `@amfi.finance` e badge laranja "🌐 Externa" para domínios externos

## v1.3.0 (2026-05-24)
- **VIP por domínio** — query de e-mails importantes agora usa `from:@amfi.finance` cobrindo todo o time automaticamente, incluindo novos contratados

## v1.2.0 (2026-05-24)
- **Notion integrado** — análise de transcrições busca Drive + Notion "Reuniões - Otallin" sempre em paralelo, combinando conteúdo das duas fontes

## v1.1.0 (2026-05-24)
- **Varredura combinada** — botão "Fazer Varredura" escaneia Drive + Gmail em paralelo (antes era só Drive)
- **Query VIP no Gmail** — e-mails de remetentes-chave (CEO, diretoria) sempre capturados independente do status de leitura
- **Tasks de IA nas seções certas** — tasks geradas pela IA aparecem em "Urgente", "Esta Semana" ou "Próximas Semanas" com badge 🤖, não em seção separada
- **Briefing para tasks de IA** — clicar no nome de qualquer task abre drawer com objetivo, pontos-chave, contexto e critério de sucesso; gerado e cacheado via `askClaude`
- **Auto-complete do Calendar** — tasks marcadas como "Realizado" na agenda são automaticamente concluídas; tasks de skill têm proteção contra falso positivo
- **Fusão de tasks relacionadas** — tasks da mesma call agrupadas num único card com briefing unificado

## v1.0.0 (2026-05-24)
- Lançamento inicial
- Extração de tarefas de Gmail, Google Drive e Google Calendar
- Artefato ao vivo com briefings detalhados por task
- Análise automática de transcrições de reuniões
- Tasks geradas por IA a partir dos próximos passos das transcrições
- Design system AmFi (magenta, Montserrat)
