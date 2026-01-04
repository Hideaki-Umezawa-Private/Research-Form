variable "github_project_path" {
  type        = string
  default     = "Hideaki-Umezawa-Private/Research-Form"
  description = "GitHub上のパス"
}

variable "app_name" {
  type        = string
  description = "一意のプロダクト名"
}
variable "environment" {
  type        = string
  description = "Deployment environment (dev, stage, prod)"
}

variable "secrets" {
  description = "SecretsManagerのシークレット情報"
}

variable "dynamodb_table_arn" {
  description = "DynamoDBテーブルのARN"
}

variable "s3_bucket_arn" {
  description = "S3バケットのARN"
}
