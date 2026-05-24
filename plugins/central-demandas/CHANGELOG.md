# Changelog — Central de Demandas

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
