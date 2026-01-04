output "dynamodb_scan_role" {
  value = aws_iam_role.dynamodb_scan
}

output "dynamodb_scan_role_arn" {
  value = aws_iam_role.dynamodb_scan.arn
}

# Lambda関数用ロールのマップ出力
output "lambda_roles" {
  description = "Lambda関数の用途別ロールARNのマップ"
  value = {
    getUsers = aws_iam_role.lambda_dynamodb_read_role.arn
    getUploadUrl = aws_iam_role.lambda_s3_presigned_role.arn
    postMediaInfo = aws_iam_role.lambda_dynamodb_write_role.arn
  }
}
