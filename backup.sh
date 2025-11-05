#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Please run script with: $0 <source_directory> <server_count>"
    echo "Example: $0 3 /var/log"
    exit 1
fi


SERVER_COUNT="$1"
SOURCE_DIR="$2"

SERVER_PREFIX="xxxx"
BACKUP_PATH="/backup${SOURCE_DIR}"

if [ ! -d "$BACKUP_PATH" ]; then
    echo "Creating new dir $BACKUP_PATH"
    mkdir -p "$BACKUP_PATH"
fi

for ((i=1; i<=SERVER_COUNT; i++)); do
    SERVER="${SERVER_PREFIX}${i}"
    DEST_DIR="${BACKUP_PATH}/${SERVER}_$(date +%F_%H-%M-%S)"
    mkdir -p "$DEST_DIR"
    rsync -az -e ssh "${SERVER}:${SOURCE_DIR}/" "$DEST_DIR/" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "$SERVER: success"
    else
        echo "$SERVER: failed"
    fi
done

echo ""
echo "Backup completed"