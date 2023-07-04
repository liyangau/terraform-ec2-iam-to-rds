output "ec2_public_ip" {
  description = "The public IP address of the EC2"
  value       = aws_instance.demo_ec2[0].public_ip
  depends_on  = [aws_instance.demo_ec2[0]]
}

output "ec2_public_dns" {
  description = "The public DNS address of the EC2"
  value       = aws_instance.demo_ec2[0].public_dns
  depends_on  = [aws_instance.demo_ec2[0]]
}

output "database_endpoint" {
  description = "The endpoint of the database"
  value       = aws_db_instance.demo_db.address
}