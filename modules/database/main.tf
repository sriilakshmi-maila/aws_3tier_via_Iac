# ==============================================================================
# 1. DATABASE SECURITY GROUP (Isolation Enforcement)
# ==============================================================================
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allows database traffic strictly from the Application Tier"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL access restricted to App Security Group"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_security_group]
  }

  egress {
    description = "Allow internal routing responses"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-db-sg" }
}

# ==============================================================================
# 2. RDS SUBNET GROUP (Multi-AZ Database Binding)
# ==============================================================================
resource "aws_db_subnet_group" "db_subnets" {
  name        = "${var.project_name}-db-subnet-group"
  subnet_ids  = var.private_subnet_ids
  description = "Spreads database instances across isolated data subnets"

  tags = { Name = "${var.project_name}-db-subnet-group" }
}

# ==============================================================================
# 3. AWS RDS MYSQL DATABASE INSTANCE
# ==============================================================================
resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  max_allocated_storage  = 100
  db_name                = "productiondb"
  engine                 = "mysql"
  engine_version         = "8.0.35"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "SrilakshmiSecurePass2026!"
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = { Name = "${var.project_name}-mysql-db" }
}

# ==============================================================================
# 4. FIXED: MODULE INPUT VARIABLES (Resolves Error)
# ==============================================================================
variable "project_name" {}
variable "vpc_id" {}
variable "private_subnet_ids" { type = list(string) }
variable "app_security_group" {}
