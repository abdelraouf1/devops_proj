# -------------------------
# Outputs
# -------------------------

output "instance_id" {
  value = aws_instance.deploy.id
}

output "instance_public_ip" {
  value = aws_instance.deploy.public_ip
}

output "instance_public_dns" {
  value = aws_instance.deploy.public_dns
}

output "vpc_id" {
  value = aws_vpc.mainvpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "security_group_id" {
  value = aws_security_group.main_sg.id
}

output "iam_instance_profile" {
  value = aws_iam_instance_profile.ec2_profile.name
}