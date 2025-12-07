#!/usr/bin/env bash
set -euo pipefail
set -x

AWS_REGION=${AWS_REGION:-ap-northeast-1}
TABLE_NAME=${TABLE_NAME:-dev-research-form-progress}

for i in $(seq 1 30); do
  if awslocal sts get-caller-identity >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

if awslocal dynamodb describe-table --table-name "${TABLE_NAME}" >/dev/null 2>&1; then
  echo "[init] dynamodb table exists: ${TABLE_NAME}"
else
  echo "[init] creating dynamodb table: ${TABLE_NAME}"
  awslocal dynamodb create-table \
    --table-name "${TABLE_NAME}" \
    --attribute-definitions \
      AttributeName=pk,AttributeType=S \
      AttributeName=sk,AttributeType=S \
      AttributeName=entityType,AttributeType=S \
    --key-schema \
      AttributeName=pk,KeyType=HASH \
      AttributeName=sk,KeyType=RANGE \
    --billing-mode PAY_PER_REQUEST \
    --global-secondary-indexes '[
        {
          "IndexName": "GSI_Questionnaire",
          "KeySchema": [
            {"AttributeName":"entityType","KeyType":"HASH"}
          ],
          "Projection": {
            "ProjectionType": "ALL"
          }
        }
      ]' \
    --region "${AWS_REGION}"
  echo "✅ DynamoDB table created!"
fi

echo "[init] done"