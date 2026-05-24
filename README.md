# AmFi Cowork Plugins

Repositório oficial de plugins da AmFi Finance para o Cowork.

## Como instalar um plugin

1. Abra o Cowork
2. Vá em **Configurações → Plugins → Adicionar marketplace**
3. Cole a URL deste repositório
4. Clique em instalar no plugin desejado

## Plugins disponíveis

### 🎯 Central de Demandas
Transforma seus e-mails, reuniões e arquivos do Drive em uma lista de tarefas organizada por urgência.

**Conectores necessários:** Gmail · Google Drive · Google Calendar

**Como usar:** após instalar, basta pedir ao Claude "gera minha central de demandas".

## Para o mantenedor (Diego)

Para publicar uma atualização:
1. Edite os arquivos na pasta `plugins/central-demandas/`
2. Atualize a versão em `plugin.json` e em `registry.json`
3. Adicione uma entrada no `CHANGELOG.md`
4. Faça commit e push — todos os usuários recebem a atualização automaticamente na próxima vez que abrirem o Cowork
