output "bastion_public_ip" {
    description = "Public IP address of the Bastion host"
    value = aws_instance.bastion.public_ip  
}

output "bastion_instance_id" {
    description = "Instance ID of the Bastion host"
    value = aws_instance.bastion.id
}