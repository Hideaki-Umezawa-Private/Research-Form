output "WorkProgressTable" {
  value = aws_dynamodb_table.work_progress_table
}

output "work_progress_table_id" {
  value = aws_dynamodb_table.work_progress_table.id
}

output "work_progress_table_arn" {
  value = aws_dynamodb_table.work_progress_table.arn
}
