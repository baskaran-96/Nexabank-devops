# ===================================================================
# Nexabank - EC2 Bastion Host Module
# ===================================================================

# Get the latest Amazon Linux 2 AMI
#==================================================================
data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

#==================================================================
# Bastion Host EC2 Instance
#==================================================================
resource "aws_instance" "bastion" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type
    subnet_id = var.public_subnet_id
    vpc_security_group_ids = [var.bastion_sg_id]
    key_name = var.key_pair_name
    associate_public_ip_address = true

    tags = {
        Name = "${var.project_name}-bastion"
        Environment = var.environment
        }
}