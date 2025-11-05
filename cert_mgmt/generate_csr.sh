#!/bin/bash

FIXED_OUTPUT_DIR="/opt/ssl/csr"
mkdir -p "$FIXED_OUTPUT_DIR"

read -p "Enter Common Name (e.g., example.com): " COMMON_NAME

echo "Select the algorithm for the private key:"
echo "1) RSA"
echo "2) EC"
echo "3) Ed25519"
read -p "Enter choice [1-3]: " ALG_CHOICE

case "$ALG_CHOICE" in
    1)
        ALGO="rsa"
        read -p "Enter RSA key size [2048]: " KEY_SIZE
        KEY_SIZE=${KEY_SIZE:-2048}
        KEY_FILE="${FIXED_OUTPUT_DIR}/${COMMON_NAME}.key"
        openssl genpkey -algorithm RSA -out "$KEY_FILE" -pkeyopt rsa_keygen_bits:"$KEY_SIZE"
        ;;
    2)
        ALGO="ec"
        echo "Available curves: prime256v1, secp384r1, secp521r1"
        read -p "Enter EC curve [prime256v1]: " CURVE
        CURVE=${CURVE:-prime256v1}
        KEY_FILE="${FIXED_OUTPUT_DIR}/${COMMON_NAME}.key"
        openssl ecparam -name "$CURVE" -genkey -noout -out "$KEY_FILE"
        ;;
    3)
        ALGO="ed25519"
        KEY_FILE="${FIXED_OUTPUT_DIR}/${COMMON_NAME}.key"
        openssl genpkey -algorithm ED25519 -out "$KEY_FILE"
        ;;
    *)
        echo "Enter choice [1-3]"
        exit 1
        ;;
esac

if [ $? -ne 0 ]; then
    echo "Failed to generate private key"
    exit 1
fi

CSR_FILE="${FIXED_OUTPUT_DIR}/${COMMON_NAME}.csr"
openssl req -new -key "$KEY_FILE" -out "$CSR_FILE" -subj "/CN=${COMMON_NAME}"

if [ $? -ne 0 ]; then
    echo "Failed to generate CSR"
    exit 1
fi

echo "Private key: $KEY_FILE"
echo "CSR: $CSR_FILE"
