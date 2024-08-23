#!/bin/bash

# Configurações
CLUSTER_NAME="cluster-todo"
SERVICE_NAME="service-todo"
HOSTED_ZONE_ID="Z09315943W3HUYZ1CG61C"
DNS_NAME="banco-todo.trustcompras.com.br"

# Obter o ID da tarefa ECS
TASK_ARN=$(aws ecs list-tasks --cluster $CLUSTER_NAME --service-name $SERVICE_NAME --query 'taskArns[0]' --output text)

# Verificar se o TASK_ARN é válido
if [ -z "$TASK_ARN" ]; then
  echo "Erro: Não foi possível obter o ID da tarefa ECS."
  exit 1
fi

# Obter o IP do container/task
TASK_IP=$(aws ecs describe-tasks --cluster $CLUSTER_NAME --tasks $TASK_ARN --query 'tasks[0].attachments[0].details[?name==`privateIPv4Address`].value' --output text)

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