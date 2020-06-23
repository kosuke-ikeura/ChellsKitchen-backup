resource "aws_db_parameter_group" "ck-rds" {
    name   = "ck-rds"
    family = "mysql5.7"

    parameter {
        name  = "character_set_database"
        value = "utf8mb4"
    }

    parameter {
        name  = "character_set_server"
        value = "utf8mb4"
    }
}

resource "aws_db_subnet_group" "ck-rds" {
    name        = "ck-rds"
    subnet_ids  = [aws_subnet.private_0.id, aws_subnet.private_1.id]
}

  
resource "aws_db_instance" "ck-rds" {
  identifier                 = "ck-rds"
  engine                     = "mysql"
  engine_version             = "5.7.25"
  instance_class             = "db.t2.micro"
  allocated_storage          = 20
  max_allocated_storage      = 100
  storage_type               = "gp2"
  storage_encrypted          = false
  username                   = var.aws_db_username
  password                   = var.aws_db_password
  # kms_key_id                 = aws_kms_key.ck-kms
  multi_az                   = true
  publicly_accessible        = false
  backup_window              = "09:10-09:40"
  backup_retention_period    = 30
  maintenance_window         = "mon:10:10-mon:10:40"
  auto_minor_version_upgrade = false
  deletion_protection        = false
  skip_final_snapshot        = true
  port                       = 3306
  apply_immediately          = false
  vpc_security_group_ids     = [module.mysql_sg.security_group_id]
  parameter_group_name       = aws_db_parameter_group.ck-rds.name
  db_subnet_group_name       = aws_db_subnet_group.ck-rds.name

  lifecycle {
    ignore_changes = [password]
  }
}

# パスワードをランダムで作成する。
# resource "random_password" "password" {
#   length            = 16
#   special           = true
#   override_special  = "_%@"
# }

module "mysql_sg" {
  source = "./security_group"
  name   = "mysql_sg"
  vpc_id = aws_vpc.chells_kitchen.id
  port   = 3306
  cidr_blocks = [aws_vpc.chells_kitchen.cidr_block]
  
}

variable "aws_db_username" {}
variable "aws_db_password" {}
