#!/usr/bin/env zsh

# Check if pass is ready
if ! command -v pass >/dev/null; then
  echo "ERROR: Install 'pass' first." && exit 1
fi

# Prompt for database type
DB_TYPES=(postgres mysql sqlite mssql duckdb)
echo "Select database type:"
select DB_TYPE in $DB_TYPES; do
  [[ -n "$DB_TYPE" ]] && break
done

# Build connection string
case $DB_TYPE in
  sqlite|duckdb)
    read "DB_PATH?Enter file path (e.g., /data/my.db or :memory:): "
    CONN_STR="$DB_TYPE:$DB_PATH"
    ;;
  *)
    read "HOST?Host (default: localhost): " && HOST="${HOST:-localhost}"
    read "PORT?Port (default: ${DB_TYPE}-default): "
    read "USER?Username: "
    read -s "PASS?Password: " && echo ""
    read "DB_NAME?Database name: "

    # Set default port if empty
    case $DB_TYPE in
      postgres) PORT=${PORT:-5432} ;;
      mysql) PORT=${PORT:-3306} ;;
      mssql) PORT=${PORT:-1433} ;;
    esac

    CONN_STR="$DB_TYPE://$USER:$PASS@$HOST:$PORT/$DB_NAME"
    ;;
esac

# Connect
echo "\nConnecting with: harlequin -a '$CONN_STR'"
harlequin -a "$CONN_STR"

# Save to pass
read -q "SAVE?Save to pass? (y/N): " && echo ""
if [[ "$SAVE" == "y" ]]; then
  read "ALIAS?Name for this connection (e.g., dev-pg): "
  echo "$CONN_STR" | pass insert -m "harlequin/connections/$ALIAS" >/dev/null
  echo "Saved to pass: harlequin/connections/$ALIAS"

  # Create alias
  read -q "ALIAS_YN?Create Zsh alias 'hq-$ALIAS'? (y/N): " && echo ""
  if [[ "$ALIAS_YN" == "y" ]]; then
    echo "alias hq-$ALIAS=\"harlequin -a \\\"\$(pass show harlequin/connections/$ALIAS | head -n1)\\\"\"" >> ~/.zshrc
    echo "Alias added. Run 'source ~/.zshrc'."
  fi
fi
