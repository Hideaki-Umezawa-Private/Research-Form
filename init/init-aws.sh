#!/usr/bin/env bash
set -euo pipefail
set -x

AWS_REGION=${AWS_REGION:-ap-northeast-1}
TABLE_NAME=${TABLE_NAME:-dev-research-form-progress}

if awslocal dynamodb describe-table --table-name "${TABLE_NAME}" >/dev/null 2>&1; then
  echo "[init] dynamodb table exists: ${TABLE_NAME}"
else
  echo "[init] creating dynamodb table: ${TABLE_NAME}"
  awslocal dynamodb create-table \
    --table-name "${TABLE_NAME}" \
    --attribute-definitions \
    AttributeName=pk,AttributeType=S \
    AttributeName=sk,AttributeType=S \
    --key-schema \
    AttributeName=pk,KeyType=HASH \
    AttributeName=sk,KeyType=RANGE \
    --billing-mode PAY_PER_REQUEST \
    --region "${AWS_REGION}"
  echo "✅ DynamoDB table created!"
fi

echo "[init] done"