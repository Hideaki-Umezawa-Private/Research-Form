variable "github_project_path" {
  type        = string
  default     = "Hideaki-Umezawa-Private/Research-Form"
  description = "GitHub上のパス"
}

variable "app_name" {
  type        = string
  default     = "research-form"
  description = "アプリ名"
}
variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment (dev, stage, prod)"
}

variable "lambda_roles" {
  type        = map(string)
  description = "関数名 -> IAM ロール ARN のマップ。例: { hello_world = \"arn:...\" }"
  default     = {}
  validation {
    condition     = alltrue([for v in values(var.lambda_roles) : can(regex("^$|^arn:", v))])
    error_message = "lambda_roles の各値は空文字か IAM ロールの ARN (arn:...) である必要があります。"
  }
}

variable "lambda_functions" {
  type        = list(string)
  description = "Lambda 関数ディレクトリ名のリスト (例: [\"hello_world\",\"put_item\"])"
  default = [
    "postQuestonnaire",
    "getQuestionnaires",
    "helloWorld"
  ]
}

variable "s3_allowed_origins" {
  type        = list(string)
  description = "S3 バケットの CORS で許可するオリジン"
  default = [
    "https://tasc.tapp.dev.dig.toyota",
    "http://localhost:5173"
  ]
}

variable "cognito_user_pool_arn" {
  type        = string
  description = "cognito user pool arn"
  default     = ""
}

locals {
  hosted_zone_name = var.environment == "prod" ? "${var.app_name}" : "${var.app_name}-dev"
}

locals {
  project_domain_name = "${local.hosted_zone_name}"
}
