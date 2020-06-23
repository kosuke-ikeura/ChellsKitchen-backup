# resource "aws_kms_key" "ck-kms" {
#     description             = "Example Customer Master Key"
#     enable_key_rotation     = true
#     is_enabled              = true
#     deletion_window_in_days = 30
# }
# 
# resource "aws_kms_alias" "ck-kms" {
#     name            = "alias/ck-kms"
#     target_key_id   = aws_kms_key.ck-kms.key_id
# }
