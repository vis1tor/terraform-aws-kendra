##################################
# Kendra Index
##################################
variable "kendra_info" {
  type = map(object({
    kendra_index_name        = string
    kendra_index_description = string
    kendra_index_role_arn    = string
    kendra_index_tags        = map(string)
    kendra_data = list(object({
      kendra_data_type          = string
      kendra_data_name          = string
      kendra_data_description   = string
      kendra_data_role_arn      = string
      kendra_data_language_code = string
      kendra_data_sync_schedule = string
      kendra_data_source_target = string
      kendra_data_tags          = map(string)
    }))
    })
  )
}