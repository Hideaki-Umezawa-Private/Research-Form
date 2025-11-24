#!/bin/bash
echo "Creating DynamoDB table ResearchFormLocalTable..."

awslocal dynamodb create-table \
  --table-name ResearchFormLocalTable \
--attribute-definitions \
  AttributeName=pk,AttributeType=S \
  AttributeName=sk,AttributeType=S \
--key-schema \
  AttributeName=pk,KeyType=HASH \
  AttributeName=sk,KeyType=RANGE \
--provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

echo "✅ DynamoDB table created!"