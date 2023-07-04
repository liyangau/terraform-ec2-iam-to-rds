resource "aws_iam_instance_profile" "rds" {
  name = "rds"
  role = aws_iam_role.rds.name
}

resource "aws_iam_role" "rds" {
  name = "rds"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.stack_name}_rds_role"
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "rds_policy" {
  name        = "rds-access-policy"
  description = "Allows EC2 instances to connect to RDS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "rds-db:connect"
        Effect   = "Allow"
        Resource = "arn:aws:rds-db:${var.region}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_db_instance.demo_db.resource_id}/kong"
      },
    ]
  })
  depends_on = [aws_db_instance.demo_db]
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.rds.name
  policy_arn = aws_iam_policy.rds_policy.arn
}