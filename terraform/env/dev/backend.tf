terraform {
  backend "s3" {
    # state を保存する S3（bootstrapで作成済み）
    bucket = "research-form-terraform-state-dev"

    # S3 内の state ファイルの保存場所
    key = "env/dev/terraform.tfstate"

    # S3 のリージョン
    region = "ap-northeast-1"

    # state ロック用 DynamoDB テーブル
    dynamodb_table = "research-form-terraform-lock-dev"

    # state を暗号化して保存
    encrypt = true
  }
}