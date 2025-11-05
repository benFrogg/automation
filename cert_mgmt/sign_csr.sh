#!/bin/bash

CA_DIR="/opt/ssl/cas"
CSR_FILE="$1"

if [ -z "$CSR_FILE" ]; then
    echo "Please run script with: $0 <csr_file>"
    exit 1
fi

if [ ! -f "$CSR_FILE" ]; then
    echo "CSR file not found: $CSR_FILE"
    exit 1
fi

echo "Available CA certificates for signing:"
CA_CERTS=()
i=1
for cert in "$CA_DIR"/*.crt "$CA_DIR"/*.pem; do
    [ -f "$cert" ] || continue
    if openssl x509 -in "$cert" -noout -text 2>/dev/null | grep -q "CA:TRUE"; then
        echo "$i) $(basename "$cert")"
        CA_CERTS+=("$cert")
        ((i++))
    fi
done

if [ ${#CA_CERTS[@]} -eq 0 ]; then
    echo "No CA certificates available for signing."
    exit 1
fi

read -p "Select CA certificate to sign with [1-${#CA_CERTS[@]}]: " choice
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#CA_CERTS[@]} ]; then
    echo "Invalid selection."
    exit 1
fi

SELECTED_CA="${CA_CERTS[$((choice-1))]}"
CA_KEY="${SELECTED_CA%.crt}.key"
OUTPUT_CERT="${CSR_FILE%.csr}.crt"

if [ ! -f "$CA_KEY" ]; then
    echo "CA key not found for $SELECTED_CA"
    exit 1
fi

openssl x509 -req -in "$CSR_FILE" -CA "$SELECTED_CA" -CAkey "$CA_KEY" \
    -CAcreateserial -out "$OUTPUT_CERT" -days 365

if [ $? -eq 0 ]; then
    echo "CSR signed successfully. Certificate: $OUTPUT_CERT"
else
    echo "Failed to sign CSR."
fi
