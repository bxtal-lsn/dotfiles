#!/usr/bin/env zsh

# Ensure 'pass' is installed
if ! command -v pass >/dev/null; then
  echo "ERROR: Install 'pass' first." && exit 1
fi

# Set alias file path
ALIAS_FILE="$HOME/.harlequin_aliases"

# Select database type
DB_TYPES=("postgresql" "mssql")
echo "Select database type:"
select DB_TYPE in "${DB_TYPES[@]}"; do
  [[ -n "$DB_TYPE" ]] && break
done

# Ensure required CLI tool is installed
if [[ "$DB_TYPE" == "mssql" ]]; then
  if ! command -v sqlcmd >/dev/null; then
    echo "ERROR: 'sqlcmd' is required for MSSQL connections. Install it and try again." && exit 1
  fi
elif [[ "$DB_TYPE" == "postgresql" ]]; then
  if ! command -v psql >/dev/null; then
    echo "ERROR: 'psql' is required for PostgreSQL connections. Install it and try again." && exit 1
  fi
fi

# Prompt for connection details
read "HOST?Enter the SQL Server host (default: localhost): " && HOST="${HOST:-localhost}"
read "PORT?Enter the SQL Server port (default: 1433): " && PORT="${PORT:-1433}"
read "USER?Enter username (default: sa): " && USER="${USER:-sa}"
read -s "PASS?Enter password: " && echo ""
read "DB_NAME?Enter database name (default: master): " && DB_NAME="${DB_NAME:-master}"

# Ask if encryption should be enabled
read "ENCRYPT?Use SSL Encryption? (yes/no, default: yes): " && ENCRYPT="${ENCRYPT:-yes}"
if [[ "$ENCRYPT" == "yes" ]]; then
  SQL_ENCRYPT="Encrypt=yes"
  SQLCMD_FLAGS="-C -N"  # Apply -C -N if encryption is on
else
  SQL_ENCRYPT="Encrypt=no"
  SQLCMD_FLAGS=""  # No -C -N if encryption is off
fi

# Ask if the certificate should be trusted
read "TRUST_CERT?Trust SSL Certificate? (yes/no, default: yes): " && TRUST_CERT="${TRUST_CERT:-yes}"
if [[ "$TRUST_CERT" == "yes" ]]; then
  SQL_TRUST="TrustServerCertificate=yes"
else
  SQL_TRUST="TrustServerCertificate=no"
fi

# Construct SQLCMD connection string
SQLCMD_CONN="-S ${HOST},${PORT} -U ${USER} -P ${PASS} -d ${DB_NAME} -l 10 ${SQLCMD_FLAGS}"

# Construct ODBC connection string
ODBC_CONN="Driver={ODBC Driver 18 for SQL Server};Server=${HOST},${PORT};Database=${DB_NAME};Uid=${USER};Pwd=${PASS};${SQL_ENCRYPT};${SQL_TRUST};Connection Timeout=30;"

# DEBUG: Print both connection strings
echo "DEBUG: SQLCMD connection -> sqlcmd $SQLCMD_CONN"
echo "DEBUG: ODBC connection -> '$ODBC_CONN'"

# Run SQLCMD test and clean up output
SQLCMD_TEST=$(sqlcmd -S ${HOST},${PORT} -U ${USER} -P ${PASS} -d ${DB_NAME} -C -N -Q "SET NOCOUNT ON; SELECT 1;" -h -1 -W 2>&1 | tr -d '\r' | awk 'NR==1 {print $1}')

# If there's an error or we don't get exactly "1", fail the test
if [[ $? -ne 0 || "$SQLCMD_TEST" != "1" ]]; then
  echo "ERROR: Connection test failed. SQLCMD output:"
  echo "$SQLCMD_TEST"
  exit 1
fi

# Check if connection succeeded
if [[ $? -ne 0 ]]; then
  echo "ERROR: Connection failed or timed out. Please check your credentials."
  exit 1
fi
# Connection test passed, continue to save the connection
echo "Connection successful!"

# Mask password before saving
MASKED_CONN_STR=$(echo "$ODBC_CONN" | sed -E 's/:(.*)@/:*****@/')

# Save connection securely
read -q "SAVE?Save to pass? (y/N): " && echo ""
if [[ "$SAVE" == "y" ]]; then
  while true; do
    read "ALIAS?Name for this connection (e.g., dev-mssql): "

    # Check if alias is empty
    if [[ -z "$ALIAS" ]]; then
      echo "ERROR: Alias cannot be empty. Try again."
      continue
    fi

    # Check if alias already exists in pass
    if pass show "harlequin/connections/$ALIAS" >/dev/null 2>&1; then
      echo "ERROR: Alias '$ALIAS' already exists in pass. Choose another name."
      continue
    fi

    # Check if alias already exists in ~/.harlequin_aliases
    if grep -q "alias hq-$ALIAS=" "$ALIAS_FILE" 2>/dev/null; then
      echo "ERROR: Alias 'hq-$ALIAS' already exists in ~/.harlequin_aliases. Choose another name."
      continue
    fi

    break  # Exit loop if alias is valid
  done

  # Save connection string securely in pass
  echo "$MASKED_CONN_STR" | pass insert -m "harlequin/connections/$ALIAS" >/dev/null
  echo "Saved to pass: harlequin/connections/$ALIAS"

  # Create alias safely
  read -q "ALIAS_YN?Create Zsh alias 'hq-$ALIAS'? (y/N): " && echo ""
  if [[ "$ALIAS_YN" == "y" ]]; then
    ALIAS_CMD="alias hq-$ALIAS='harlequin -a odbc \"\$(pass show harlequin/connections/$ALIAS)\"'"

    # Append alias to ~/.harlequin_aliases if it doesn’t already exist
    echo "$ALIAS_CMD" >> "$ALIAS_FILE"
    echo "Alias added to $ALIAS_FILE. Run 'source ~/.zshrc' or restart your shell."
  fi
fi

# Run Harlequin with the ODBC connection string
harlequin -a odbc "$ODBC_CONN"

