resource "aws_vpc_security_group_ingress_rule" "ec2_ssh_ingress" {
  security_group_id = aws_security_group.ec2_sg.id
  description       = "EC2 Ingress rule to allow SSH"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "ec2_kong_http_ingress" {
  security_group_id = aws_security_group.ec2_sg.id
  description       = "EC2 Ingress rule to allow traffic to port 8000 which is Kong proxy http"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8000
  ip_protocol = "tcp"
  to_port     = 8000
}

resource "aws_vpc_security_group_ingress_rule" "ec2_kong_https_ingress" {
  security_group_id = aws_security_group.ec2_sg.id
  description       = "EC2 Ingress rule to allow traffic to port 8443 which is Kong proxy https"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8443
  ip_protocol = "tcp"
  to_port     = 8443
}

resource "aws_vpc_security_group_egress_rule" "ec2_kong_egress_to_all" {
  security_group_id = aws_security_group.ec2_sg.id
  description       = "EC2 Egress rule to allow request going out to all IPs and ports"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group for EC2"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.stack_name}_ec2_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "db_ingress_from_ec2" {
  security_group_id = aws_security_group.db_sg.id
  description       = "Database ingress rule to allow connection at port 5432 if requests are coming from instance with ec2_sg"

  referenced_security_group_id = aws_security_group.ec2_sg.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Security group for database"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.stack_name}_db_sg"
  }
}