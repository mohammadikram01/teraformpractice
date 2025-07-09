output "ami" {
  value = aws_instance.name.ami
}

output "subnetid" {
  value = aws_instance.name.subnet_id
}