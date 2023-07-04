data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.stack_name}_ssh_key"
  public_key = file("~/.ssh/kong-aws-iam-demo.key.pub")
}

resource "aws_instance" "demo_ec2" {
  count                       = var.settings.ec2.count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.settings.ec2.instance_type
  subnet_id                   = aws_subnet.public[count.index].id
  key_name                    = aws_key_pair.ssh_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.rds.name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "${var.stack_name}_ec2_${count.index}"
  }

  metadata_options {
    http_tokens = var.settings.ec2.http_tokens
    http_endpoint = var.settings.ec2.http_endpoint
    http_put_response_hop_limit = var.settings.ec2.http_put_response_hop_limit
  }
  depends_on = [aws_iam_policy.rds_policy]
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "db_subnet_group"
  description = "DB subnet group for database"
  subnet_ids  = [for subnet in aws_subnet.private : subnet.id]
}

resource "aws_db_instance" "demo_db" {
  allocated_storage                   = var.settings.database.allocated_storage
  engine                              = var.settings.database.engine
  engine_version                      = var.settings.database.engine_version
  instance_class                      = var.settings.database.instance_class
  db_name                             = var.settings.database.db_name
  parameter_group_name                = var.settings.database.parameter_group_name
  iam_database_authentication_enabled = var.settings.database.iam_database_authentication_enabled
  ca_cert_identifier                  = var.settings.database.ca_cert_identifier
  username                            = var.db_username
  password                            = var.db_password
  identifier                          = "${var.stack_name}-pg"
  db_subnet_group_name                = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids              = [aws_security_group.db_sg.id]
  skip_final_snapshot                 = var.settings.database.skip_final_snapshot
  apply_immediately                   = true
  tags = {
    Name = "${var.stack_name}_rds_pg"
  }
}