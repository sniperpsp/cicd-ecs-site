#!/bin/bash

# Configurações
CLUSTER_NAME="cluster-todo"
SERVICE_NAME="service-todo"
HOSTED_ZONE_ID="Z09315943W3HUYZ1CG61C"
DNS_NAME="banco-todo.trustcompras.com.br"

# Obter o ID da tarefa ECS
TASK_ID=$(aws ecs list-tasks --cluster $CLUSTER_NAME --service-name $SERVICE_NAME --query 'taskArns[0]' --output text)

# Obter o IP do container/task
TASK_IP=$(aws ecs describe-tasks --cluster $CLUSTER_NAME --tasks $TASK_ID --query 'tasks[0].attachments[0].details[?name==`privateIPv4Address`].value' --output text)

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