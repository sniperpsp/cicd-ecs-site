#!/bin/bash

# Obter o ID da tarefa ECS
TASK_ID=$(aws ecs list-tasks --cluster <cluster_name> --service-name <service_name> --query 'taskArns[0]' --output text)

# Obter o IP do container/task
TASK_IP=$(aws ecs describe-tasks --cluster <cluster_name> --tasks $TASK_ID --query 'tasks[0].attachments[0].details[?name==`privateIPv4Address`].value' --output text)

# Atualizar o registro DNS
aws route53 change-resource-record-sets --hosted-zone-id Z09315943W3HUYZ1CG61C --change-batch '{
  "Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "banco-todo.trustcompras.com.br",
      "Type": "A",
      "TTL": 60,
      "ResourceRecords": [{"Value": "'"$TASK_IP"'"}]
    }
  }]
}'