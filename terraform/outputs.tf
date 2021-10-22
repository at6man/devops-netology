output "aws_account_id" {
    value = data.aws_caller_identity.current.account_id
}

output "aws_user_id" {
    value = data.aws_caller_identity.current.user_id
}

output "aws_region" {
    value = data.aws_region.current.name
}

output "aws_instance_ip_addr" {
    value = aws_instance.server.*.private_ip
}

output "aws_instance_subnet_id" {
    value = aws_instance.server.*.subnet_id
}