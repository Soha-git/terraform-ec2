output "public_dns_hostname" {
    value = aws_instance.web-site.public_dns
}
output "public_ip" {
    value = aws_instance.web-site.public_ip
}