#!/bin/bash

LOG_DIR="$1"
DAYS="${2:-7}"

if [ -z "$LOG_DIR" ]; then
    echo "Please run script with (default 7 days): $0 <log_directory> <days_to_keep>"
    echo "Example: $0 /var/log/     OR     $0 /var/log/ 14"
    exit 1
fi

if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory $LOG_DIR does not exist"
    exit 1
fi

find "$LOG_DIR" -type f -mtime +$DAYS -exec rm -f {} \;

echo "$(date '+%F %T') - Cleaned logs older than $DAYS days from $LOG_DIR"