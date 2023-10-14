#!/bin/bash

# Endereço do servidor
SERVER_URL="http://192.168.15.100:5000"

# Endpoint Register
REGISTER_ENDPOINT="$SERVER_URL/register"

# Endpoint Generate QRCode
QRCODE_ENDPOINT="$SERVER_URL/generate_qrcode"

# Solicitação ao endpoint Register
response=$(curl -s -o - -w "\n%{http_code}" -H "Content-Type: application/json" -X POST -d '{"username": "testUser", "password": "testPass"}' $REGISTER_ENDPOINT)

http_code=$(echo "$response" | tail -n1)
response_body=$(echo "$response" | head -n -1)

if [[ $http_code -ne 200 ]]; then
    echo "Failed to register. Response code: $http_code"
    echo "Response body: $response_body"
    exit 1
fi

# Extrai a api_key da resposta
api_key=$(echo "$response_body" | jq -r '.api_key')

if [[ -z "$api_key" ]]; then
    echo "Failed to extract api_key from response."
    exit 1
fi

# Solicitação ao endpoint Generate QRCode
http_code=$(curl -s -o /dev/null -w "%{http_code}" -H "Content-Type: application/json" -H "x-api-key: $api_key" -X POST -d '{"content": "www.linkedin.com/in/caiohenrks"}' $QRCODE_ENDPOINT)

if [[ $http_code -ne 200 && $http_code -ne 401 ]]; then
    echo "Failed to generate QRCode. Response code: $http_code"
    exit 1
fi

echo "Script completed successfully!"
