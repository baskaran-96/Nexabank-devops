# ============================================================
# NexaBank - RDS PostgreSQL Module
# ============================================================

# -----------------------------------------------------------
# RDS Subnet Group
# Tells RDS which subnets to use
# -----------------------------------------------------------
resource "aws_db_subnet_group" "nexabank" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.project_name}-db-subnet-group"
    Environment = var.environment
  }
}

# -----------------------------------------------------------
# RDS PostgreSQL Instance
# -----------------------------------------------------------
resource "aws_db_instance" "nexabank" {
  identifier        = "${var.project_name}-db"
  engine            = "postgres"
  engine_version    = "15.7"
  instance_class    = var.instance_class
  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.nexabank.name
  vpc_security_group_ids = [var.rds_sg_id]

  multi_az               = true
  publicly_accessible    = false
  skip_final_snapshot    = true
  deletion_protection    = false

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  tags = {
    Name        = "${var.project_name}-db"
    Environment = var.environment
  }
}