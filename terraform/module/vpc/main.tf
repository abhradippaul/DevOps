resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_internet_gateway" "public_gateway" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    "Name" = "Public Internet Gateway"
  }
}

resource "aws_subnet" "eks_subnet_public" {
  vpc_id                  = aws_vpc.eks_vpc.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.az_zones[count.index]
  map_public_ip_on_launch = true


  tags = {
    "Name"                   = "eks_subnet_public-${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "eks_subnet_private" {
  vpc_id                  = aws_vpc.eks_vpc.id
  count                   = length(var.private_subnet_cidrs)
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.az_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name"                            = "eks_subnet_private-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_eip" "nat_elastic_ip" {
  tags = {
    "Name" = "nat_elastic_ip"
  }
}

resource "aws_nat_gateway" "nat_private_ec2" {
  depends_on    = [aws_eip.nat_elastic_ip]
  allocation_id = aws_eip.nat_elastic_ip.id
  subnet_id     = aws_subnet.demo-subnet-public[0].id
  tags = {
    "Name" = "nat_private_ec2"
  }
}

resource "aws_route_table" "eks_private_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  #   route {
  #     cidr_block = "0.0.0.0/0"
  #     gateway_id = aws_nat_gateway.nat_private_ec2.id
  #   }

  tags = {
    "Name" = "eks_private_route_table"
  }
}


resource "aws_route_table" "eks_public_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_gateway.id
  }

  tags = {
    "Name" = "eks_public_route_table"
  }
}

resource "aws_route_table_association" "public_subnet_assign" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.eks_subnet_public[count.index].id
  route_table_id = aws_route_table.eks_public_route_table.id
}
resource "aws_route_table_association" "private_subnet_assign" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.eks_subnet_private[count.index].id
  route_table_id = aws_route_table.eks_private_route_table.id
}

resource "aws_network_acl" "eks_network_acl_public" {
  vpc_id = aws_vpc.eks_vpc.id

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    "Name" = "eks_network_acl_public"
  }
}
resource "aws_network_acl" "eks_network_acl_private" {
  vpc_id = aws_vpc.eks_vpc.id

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    rule_no    = 100
    protocol   = -1 # all protocols
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  # Allow return traffic from NAT gateway (ephemeral ports)
  ingress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  tags = {
    "Name" = "eks_network_acl_private"
  }
}

resource "aws_network_acl_association" "public_subnet_assign" {
  count          = length(var.public_subnet_cidrs)
  network_acl_id = aws_network_acl.eks_network_acl_public.id
  subnet_id      = aws_subnet.eks_subnet_public[count.index].id
}

resource "aws_network_acl_association" "private_subnet_assign" {
  count          = length(var.private_subnet_cidrs)
  network_acl_id = aws_network_acl.eks_network_acl_private.id
  subnet_id      = aws_subnet.eks_subnet_private[count.index].id
}
