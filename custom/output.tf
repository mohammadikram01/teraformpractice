output "serverpublicid" {
  value = aws_instance.publicserver.id
}
output "serverpvtid" {
  value = aws_instance.pvtserver.id
}
output "vpcid" {
  value = aws_vpc.name.id
}
output "subnetpubid" {
  value = aws_subnet.publicsubnet.id
}
output "subnetpvtid" {
  value = aws_subnet.privatesubnet.id
}
output "sgid" {
    value = aws_security_group.name.id
}
output "InternetGatway" {
  value = aws_internet_gateway.InternetGatway.id
}
output "natgatway" {
  value = aws_nat_gateway.natgatway.id
}
