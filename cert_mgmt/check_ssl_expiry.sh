#!/bin/bash

CERT_DIR="/opt/ssl/certs"

CERTS=("$CERT_DIR"/*)
if [ ${#CERTS[@]} -eq 0 ]; then
    echo "No certificates found in $CERT_DIR"
    exit 1
fi

echo "Available certificates:"
for i in "${!CERTS[@]}"; do
    echo "$((i+1))) $(basename "${CERTS[$i]}")"
done

read -p "Choose which cert for check: " CHOICE

if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt "${#CERTS[@]}" ]; then
    echo "Invalid choice"
    exit 1
fi

SELECTED_CERT="${CERTS[$((CHOICE-1))]}"
echo "Checking certificate: $SELECTED_CERT"

EXPIRY_DATE=$(openssl x509 -in "$SELECTED_CERT" -noout -enddate | cut -d= -f2)
if [ -z "$EXPIRY_DATE" ]; then
    echo "Unable to read cert, make sure cert is .crt or .pem"
    exit 1
fi

EXPIRY_SECONDS=$(date -d "$EXPIRY_DATE" +%s)
CURRENT_SECONDS=$(date +%s)
DAYS_LEFT=$(( (EXPIRY_SECONDS - CURRENT_SECONDS) / 86400 ))

echo "Certificate expires on: $EXPIRY_DATE"
echo "Days remaining: $DAYS_LEFT"
