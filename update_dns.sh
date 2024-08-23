#!/bin/bash

# Configurações
HOSTED_ZONE_ID="Z09315943W3HUYZ1CG61C"
DNS_NAME="banco-todo.trustcompras.com.br"

# Obter o IP público do container
TASK_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# Verificar se o TASK_IP é um IPv4 válido
if [[ ! $TASK_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Erro: O IP obtido não é um endereço IPv4 válido."
  exit 1
fi

# Atualizar o registro DNS
aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch '{
  "Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "'"$DNS_NAME"'",
      "Type": "A",
      "TTL": 60,
      "ResourceRecords": [{"Value": "'"$TASK_IP"'"}]
    }
  }]
}'