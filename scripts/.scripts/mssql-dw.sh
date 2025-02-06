#!/bin/bash
# Fetch credentials
USER=$(pass db/dev/postgres16/username)
PASS=$(pass db/dev/postgres16/password)

# Build connection string
CONN_STRING="postgres://$USER:$PASS@localhost:5555"

# Launch Harlequin
harlequin -a postgres "$CONN_STRING"

