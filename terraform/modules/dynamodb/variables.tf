variable "environment" {
  type        = string
  default     = null
  description = "Deployment environment (dev, stage, prod)"
}

variable "app_name" {
  type        = string
  description = "一意のプロダクト名"
}
