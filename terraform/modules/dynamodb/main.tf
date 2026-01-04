resource "aws_dynamodb_table" "work_progress_table" {
  name = "${var.environment}-${var.app_name}-work-progress"

  hash_key  = "pk"
  range_key = "sk"
  attribute {
    name = "pk"
    type = "S"
  }
  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "entityType"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"

  point_in_time_recovery {
    enabled = true
  }

  global_secondary_index {
    name            = "GSI_Questionnaire"
    hash_key        = "entityType"
    projection_type = "ALL"
  }
}