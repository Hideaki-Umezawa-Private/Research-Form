variable "environment" {
    type        = string
    description = "Deployment environment (dev, stage, prod)"
}

variable "function_name" {
    type        = string
    description = "Base name of the Lambda function (env suffix is added automatically)"
}

variable "filename" {
    type        = string
    description = "Lambda デプロイパッケージのファイル名"
}

variable "handler" {
    type        = string
    description = "Lambda ハンドラー名 (例: index.handler)"
}

variable "runtime" {
  description = "Lambda runtime (e.g. nodejs20.x)"
  type        = string
}

variable "timeout" {
  description = "Lambda timeout (seconds)"
  type        = number
  default     = 10
}

variable "memory_size" {
  description = "Lambda memory size (MB)"
  type        = number
  default     = 128
}