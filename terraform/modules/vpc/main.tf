#====================================================================
# Terraform Module: VPC (Nexabank VPC Module)
#====================================================================

#---------------------------
# VPC Creation
#---------------------------
resource "aws_vpc" "nexabank_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "${var.project_name}-vpc"
        Environment = var.environment
    }
}

#==================================
#Public Subnets Creation (one per AZ)
#Used by : Load Balancers, NAT Gateways, Bastion Hosts
#==================================
resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.nexabank_vpc.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-public-subnet-${count.index + 1}"
        Environment = var.environment
    }
}

#==================================
#Private Subnets Creation (one per AZ)
#Used by : EKS Worker Nodes, RDS , Backend Services
#==================================
resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.nexabank_vpc.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    
    tags = {
        Name = "${var.project_name}-private-subnet-${count.index + 1}"
        Environment = var.environment
    }
}

#==================================
#Internet Gateway Creation
#Allows public subnets to reach the internet
#==================================
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.nexabank_vpc.id

    tags = {
        Name = "${var.project_name}-igw"
        Environment = var.environment
    }
}

#==================================
#Elastic IPs for NAT Gateways (one per AZ for high availability)
#==================================
resource "aws_eip" "nat" {
    count = length(var.public_subnet_cidrs)
    domain = "vpc"

    tags = {
        Name = "${var.project_name}-nat-eip-${count.index +1}"
        Environment = var.environment
    }

    depends_on = [aws_internet_gateway.igw]
}

#==================================
#NAT Gateways Creation (one per AZ for high availability)
#Allows private subnets to access the internet for updates, patches, etc.
#==================================
resource "aws_nat_gateway" "nat" {
    count = length(var.public_subnet_cidrs)
    allocation_id = aws_eip.nat[count.index].id
    subnet_id = aws_subnet.public[count.index].id

    tags = {
        Name = "${var.project_name}-nat-${count.index +1}"
        Environment = var.environment
    }

    depends_on = [ aws_internet_gateway.igw]
}

# -----------------------------------------------------------
# Public Route Table
# Routes all public traffic through Internet Gateway
# -----------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.nexabank_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = var.environment
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# -----------------------------------------------------------
# Private Route Tables (one per AZ)
# Each routes through its own NAT Gateway for HA
# -----------------------------------------------------------
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.nexabank_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name        = "${var.project_name}-private-rt-${count.index + 1}"
    Environment = var.environment
  }
}

# Associate private subnets with private route tables
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}