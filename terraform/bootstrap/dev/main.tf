#  Terraform の state 管理基盤を作るコード
# S3 バケットと DynamoDB テーブルを作成

# state保存用S3
resource "aws_s3_bucket" "tfstate" {
  bucket = "research-form-terraform-state-dev"

  # 誤って terraform destroy されないようにする安全装置
  # state が消えると全リソースが「存在しない」扱いになるため必須
  lifecycle {
    prevent_destroy = true
  }
}

# stateの履歴管理
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  # バージョン管理を有効化
  versioning_configuration {
    status = "Enabled"
  }
}

# stateロック 役割:Terraformの同時実行防止
resource "aws_dynamodb_table" "tfstate_lock" {
  name = "research-form-terraform-lock-dev"

  # 利用頻度が低いためオンデマンド課金を使用
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }
}