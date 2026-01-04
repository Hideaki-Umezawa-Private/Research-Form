#---------------------------------------------------------------------------------------
#--- SecretsManager Policy
#---------------------------------------------------------------------------------------
resource "aws_iam_policy" "secrets_get_secret_value" {
  name = "${var.app_name}-SecretsManager-Get-Secret-Value-${var.environment}"
  policy = templatefile("${path.module}/../../modules/iam/policies/secrets_get_secret_value.json", {
    secrets_arn = var.secrets.arn
  })
}
#---------------------------------------------------------------------------------------
#--- DynamoDB Policy
#---------------------------------------------------------------------------------------
resource "aws_iam_policy" "dynamodb_query" {
  name = "${var.app_name}-DynamoDB-Query-${var.environment}"
  policy = templatefile("${path.module}/../../modules/iam/policies/dynamodb_query.json", {
    table_arn = var.dynamodb_table_arn
  })
}

resource "aws_iam_policy" "dynamodb_get_item" {
  name = "${var.app_name}-DynamoDB-GetItem-${var.environment}"
  policy = templatefile("${path.module}/../../modules/iam/policies/dynamodb_get_item.json", {
    table_arn = var.dynamodb_table_arn
  })
}

resource "aws_iam_policy" "dynamodb_batch_get_item" {
  name = "${var.app_name}-DynamoDB-BatchGetItem-${var.environment}"
  policy = templatefile("${path.module}/../../modules/iam/policies/dynamodb_batch_get_item.json", {
    table_arn = var.dynamodb_table_arn
  })
}

resource "aws_iam_policy" "dynamodb_put_item" {
  name = "${var.app_name}-DynamoDB-PutItem-${var.environment}"
  policy = templatefile("${path.module}/../../modules/iam/policies/dynamodb_put_item.json", {
    table_arn = var.dynamodb_table_arn
  })
}

resource "aws_iam_policy" "dynamodb_update_item" {
  name = "${var.app_name}-DynamoDB-UpdateItem-${var.environment}"
  policy = templatefile("${path.module}/../../modules/iam/policies/dynamodb_update_item.json", {
    table_arn = var.dynamodb_table_arn
  })
}

resource "aws_iam_policy" "dynamodb_scan" {
  name = "${var.app_name}-DynamoDB-Scan-${var.environment}"
  policy = templatefile("${path.module}/../../modules/iam/policies/dynamodb_scan.json", {
    table_arn = var.dynamodb_table_arn
  })
}

#---------------------------------------------------------------------------------------
#--- S3 Policy
#---------------------------------------------------------------------------------------
resource "aws_iam_policy" "s3_read_only" {
  name = "${var.app_name}-S3-ReadOnly-${var.environment}"
  policy = templatefile("${path.module}/policies/s3_read_only.json", {
    bucket_arn = var.s3_bucket_arn
  })
}

resource "aws_iam_policy" "s3_write" {
  name = "${var.app_name}-S3-Write-${var.environment}"
  policy = templatefile("${path.module}/policies/s3_write.json", {
    bucket_arn = var.s3_bucket_arn
  })
}

resource "aws_iam_policy" "s3_presigned_url" {
  name = "${var.app_name}-S3-PresignedURL-${var.environment}"
  policy = templatefile("${path.module}/policies/s3_presigned_url.json", {
    bucket_arn = var.s3_bucket_arn
  })
}

#---------------------------------------------------------------------------------------
#--- DynamoDB Policy
#---------------------------------------------------------------------------------------
resource "aws_iam_role" "dynamodb_scan" {
  name                 = "${var.environment}-${var.app_name}-dynamodb_scan-role"
  description          = "${var.environment}-${var.app_name}-dynamodb_scan-role"
  max_session_duration = 3600
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_scan_role_attachment" {
  for_each = {
    dynamodb_scan = aws_iam_policy.dynamodb_scan.arn
    lambda_basic  = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
  }
  role       = aws_iam_role.dynamodb_scan.name
  policy_arn = each.value
  depends_on = [aws_iam_policy.dynamodb_scan]
}

#---------------------------------------------------------------------------------------
#--- EventBridge Role
#---------------------------------------------------------------------------------------
## Data Sources ############################################
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "github_oidc_policy_document" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.id]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${data.aws_iam_openid_connect_provider.github.url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "${data.aws_iam_openid_connect_provider.github.url}:sub"
      values   = ["repo:${var.github_project_path}:*"]
    }
  }
}

## Resources ###############################################
resource "aws_iam_policy" "github_oidc_policy" {
  name        = "${var.environment}-${var.app_name}-github-oidc-policy"
  description = "${var.environment}-${var.app_name}-github-oidc-policy"
  policy      = file("../../modules/policies/github_oidc/iam_policy.json")
}

resource "aws_iam_role" "github-oidc-role" {
  name                 = "${var.environment}-${var.app_name}-github-oidc-role"
  path                 = "/"
  description          = "${var.environment}-${var.app_name}-github-oidc-role"
  max_session_duration = 3600
  assume_role_policy   = data.aws_iam_policy_document.github_oidc_policy_document.json
}

resource "aws_iam_role_policy_attachment" "github_oidc_policy_attachment" {
  role       = aws_iam_role.github-oidc-role.name
  policy_arn = aws_iam_policy.github_oidc_policy.arn
}

## Outputs #################################################
output "github_oidc_role_arn" {
  description = "github OIDC role ARN"
  value       = aws_iam_role.github-oidc-role.arn
}

#---------------------------------------------------------------------------------------
#--- Lambda SQS SendMessage Role & Policy
#---------------------------------------------------------------------------------------
data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#---------------------------------------------------------------------------------------
#--- Lambda
#---------------------------------------------------------------------------------------
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# 基本実行ロール（ログ出力のみ）
resource "aws_iam_role" "lambda_basic_execution_role" {
  name               = "${var.environment}-lambda-basic-execution-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_role_attachment" {
  role       = aws_iam_role.lambda_basic_execution_role.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

# DynamoDB読み取り専用ロール
resource "aws_iam_role" "lambda_dynamodb_read_role" {
  name               = "${var.environment}-lambda-dynamodb-read-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_read_role_attachments" {
  for_each = {
    basic_execution = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
    dynamodb_query  = aws_iam_policy.dynamodb_query.arn
    dynamodb_get    = aws_iam_policy.dynamodb_get_item.arn
    dynamodb_scan   = aws_iam_policy.dynamodb_scan.arn
    dynamodb_batch_get = aws_iam_policy.dynamodb_batch_get_item.arn
  }
  role       = aws_iam_role.lambda_dynamodb_read_role.name
  policy_arn = each.value
}

# DynamoDB読み書きロール
resource "aws_iam_role" "lambda_dynamodb_write_role" {
  name               = "${var.environment}-lambda-dynamodb-write-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_write_role_attachments" {
  for_each = {
    basic_execution = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
    dynamodb_query  = aws_iam_policy.dynamodb_query.arn
    dynamodb_get    = aws_iam_policy.dynamodb_get_item.arn
    dynamodb_put    = aws_iam_policy.dynamodb_put_item.arn
    dynamodb_update = aws_iam_policy.dynamodb_update_item.arn
    dynamodb_scan   = aws_iam_policy.dynamodb_scan.arn
  }
  role       = aws_iam_role.lambda_dynamodb_write_role.name
  policy_arn = each.value
}

# Secrets Manager アクセスロール
resource "aws_iam_role" "lambda_secrets_role" {
  name               = "${var.environment}-lambda-secrets-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_secrets_role_attachments" {
  for_each = {
    basic_execution = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
    secrets_access  = aws_iam_policy.secrets_get_secret_value.arn
  }
  role       = aws_iam_role.lambda_secrets_role.name
  policy_arn = each.value
}

# フルアクセスロール（DynamoDB + Secrets Manager）
resource "aws_iam_role" "lambda_full_access_role" {
  name               = "${var.environment}-lambda-full-access-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_full_access_role_attachments" {
  for_each = {
    basic_execution = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
    dynamodb_query  = aws_iam_policy.dynamodb_query.arn
    dynamodb_get    = aws_iam_policy.dynamodb_get_item.arn
    dynamodb_put    = aws_iam_policy.dynamodb_put_item.arn
    dynamodb_update = aws_iam_policy.dynamodb_update_item.arn
    dynamodb_scan   = aws_iam_policy.dynamodb_scan.arn
    secrets_access  = aws_iam_policy.secrets_get_secret_value.arn
  }
  role       = aws_iam_role.lambda_full_access_role.name
  policy_arn = each.value
}

# S3読み取り専用ロール
resource "aws_iam_role" "lambda_s3_read_role" {
  name               = "${var.environment}-lambda-s3-read-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_s3_read_role_attachments" {
  for_each = {
    basic_execution = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
    s3_read         = aws_iam_policy.s3_read_only.arn
  }
  role       = aws_iam_role.lambda_s3_read_role.name
  policy_arn = each.value
}

# S3書き込みロール
resource "aws_iam_role" "lambda_s3_write_role" {
  name               = "${var.environment}-lambda-s3-write-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_s3_write_role_attachments" {
  for_each = {
    basic_execution = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
    s3_read         = aws_iam_policy.s3_read_only.arn
    s3_write        = aws_iam_policy.s3_write.arn
  }
  role       = aws_iam_role.lambda_s3_write_role.name
  policy_arn = each.value
}

# S3 presigned URLロール（読み書き両対応）
resource "aws_iam_role" "lambda_s3_presigned_role" {
  name               = "${var.environment}-lambda-s3-presigned-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_s3_presigned_role_attachments" {
  for_each = {
    basic_execution = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
    s3_presigned    = aws_iam_policy.s3_presigned_url.arn
  }
  role       = aws_iam_role.lambda_s3_presigned_role.name
  policy_arn = each.value
}

# メディア処理フルアクセスロール（DynamoDB + S3 + Secrets Manager）
resource "aws_iam_role" "lambda_media_full_access_role" {
  name               = "${var.environment}-lambda-media-full-access-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_media_full_access_role_attachments" {
  for_each = {
    basic_execution = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
    dynamodb_query  = aws_iam_policy.dynamodb_query.arn
    dynamodb_get    = aws_iam_policy.dynamodb_get_item.arn
    dynamodb_put    = aws_iam_policy.dynamodb_put_item.arn
    dynamodb_update = aws_iam_policy.dynamodb_update_item.arn
    dynamodb_scan   = aws_iam_policy.dynamodb_scan.arn
    s3_presigned    = aws_iam_policy.s3_presigned_url.arn
    secrets_access  = aws_iam_policy.secrets_get_secret_value.arn
  }
  role       = aws_iam_role.lambda_media_full_access_role.name
  policy_arn = each.value
}

