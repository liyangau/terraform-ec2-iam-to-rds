variable "profile" {
  default = "cx"
}

variable "region" {
  default = "ap-southeast-2"
}

variable "stack_name" {
  type    = string
  default = "demo"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "168.186.0.0/16"
}

variable "subnet_count" {
  description = "Number of subnets"
  type        = map(number)
  default = {
    public  = 1,
    private = 2
  }
}

variable "settings" {
  description = "Configuration settings"
  type        = map(any)
  default = {
    "database" = {
      allocated_storage                   = 10
      engine                              = "postgres"
      engine_version                      = "14.8"
      parameter_group_name                = "default.postgres14"
      instance_class                      = "db.t3.micro"
      db_name                             = "kong"
      ca_cert_identifier                  = "rds-ca-ecc384-g1"
      skip_final_snapshot                 = true
      iam_database_authentication_enabled = true
    },

    "ec2" = {
      count         = 1
      instance_type = "t2.micro"
      http_endpoint = "enabled"
      http_tokens = "optional"
      http_put_response_hop_limit = 1
    }
  }
}

variable "public_subnet_cidr_blocks" {
  description = "Available CIDR blocks for public subnets"
  type        = list(string)
  default = [
    "168.186.1.0/24",
    "168.186.2.0/24",
    "168.186.3.0/24",
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "Available CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "168.186.101.0/24",
    "168.186.102.0/24",
    "168.186.103.0/24",
  ]
}

variable "db_username" {
  description = "Database master user"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database master user password"
  type        = string
  sensitive   = true
}