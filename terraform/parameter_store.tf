# resource "aws_ssm_parameter" "rds_password" {
#   name   = "/rds/password"
#   type   = "SecureString" # KMSで暗号化して保存
#   key_id = "d7e2fabe-9d1f-4cd5-9c78-d7df0a6bc0be" # 暗号化に使う KMS key のID
#   value  = aws_db_instance.ck-rds.password # RDSリソースのパスワードを参照
# }