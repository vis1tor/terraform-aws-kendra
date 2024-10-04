locals {
  data_source_info = { for k, v in flatten([
    for k, v in var.kendra_info : [
      for kd in v.kendra_data : merge(kd, {
        kendra_index_name = v.kendra_index_name
      })
    ]
  ]) : k => v }
}

resource "aws_kendra_index" "this" {
  for_each = { for k, v in var.kendra_info : v.kendra_index_name => v if v.kendra_index_name != "" }

  name        = each.value.kendra_index_name
  description = each.value.kendra_index_description
  edition     = "DEVELOPER_EDITION"
  role_arn    = each.value.kendra_index_role_arn

  tags = each.value.kendra_index_tags
}

resource "aws_kendra_data_source" "this" {
  for_each = { for k, v in local.data_source_info : v.kendra_data_name => v }

  index_id      = aws_kendra_index.this[each.value.kendra_index_name].id
  type          = each.value.kendra_data_type
  name          = each.value.kendra_data_name
  description   = each.value.kendra_data_description
  role_arn      = each.value.kendra_data_role_arn
  language_code = each.value.kendra_data_language_code
  schedule      = try(each.value.kendra_data_sync_schedule, null)

  configuration {
    s3_configuration {
      bucket_name = each.value.kendra_data_type == "S3" ? each.value.kendra_data_source_target : ""
    }
  }

  tags = each.value.kendra_data_tags
}