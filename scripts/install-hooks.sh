#!/bin/sh
# install-hooks.sh
# Execute uma vez após clonar o repositório para instalar os git hooks da AmFi.
# Uso: sh scripts/install-hooks.sh

HOOKS_DIR=".git/hooks"

if [ ! -d "$HOOKS_DIR" ]; then
  echo "❌ Execute este script a partir da raiz do repositório."
  exit 1
fi

cat > "$HOOKS_DIR/pre-commit" << 'HOOK'
#!/bin/sh
# pre-commit hook: verifica se arquivos HTML críticos estão completos antes de commitar

ERRORS=0

for file in $(git diff --cached --name-only | grep "\.html$"); do
  if [ -f "$file" ]; then
    LAST_LINE=$(tail -1 "$file" | tr -d '[:space:]')
    if [ "$LAST_LINE" != "</html>" ]; then
      echo "❌ ERRO: '$file' parece estar truncado (última linha: '$(tail -1 "$file")')"
      echo "   O arquivo deve terminar com </html>"
      ERRORS=1
    else
      echo "✅ '$file' verificado — arquivo completo."
    fi
  fi
done

if [ $ERRORS -ne 0 ]; then
  echo ""
  echo "Commit bloqueado. Corrija os arquivos acima antes de commitar."
  exit 1
fi

exit 0
HOOK

chmod +x "$HOOKS_DIR/pre-commit"
echo "✅ Hooks instalados com sucesso!"
