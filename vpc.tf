# Creation of VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidrs[0]
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = merge(
    var.global_tags,
    {
      "Name"          = "main",
      "resource_type" = "vpc",
      "VPC_Category"  = "main",
      "Creation Date" = "${timestamp()}"
    }
  )
}


# Creation of Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main_igw"
  }
}

# Creation of Subnets

resource "aws_subnet" "public_subnet" {
  count = length(var.priv_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.pub_subnet_cidrs[count.index]
  availability_zone = var.avail_zones[count.index]
  map_public_ip_on_launch = true # This ensures that pub IPs are assigned to instances within this SN
  tags = merge(
    var.global_tags,
    {
      "Name"          = format("public-subnet-%d", count.index + 1),
      "resource_type" = "subnet",
      "Network"       = "public",
      "Creation Date" = "${timestamp()}"
    }
  )
}

resource "aws_subnet" "private_subnet" {
  count = length(var.priv_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.priv_subnet_cidrs[count.index]
  availability_zone = var.avail_zones[count.index]
 
  tags = merge(
    var.global_tags,
    {
      "Name"          = format("private-subnet-%d", count.index + 1),
      "resource_type" = "subnet",
      "Network"       = "private",
      "Creation Date" = "${timestamp()}"
    }
  )
}


# CREATION OF NAT Gateway
resource "aws_eip" "nat" {
  
  tags = {
    Name = "main_nat_eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id #Uusing the first public subnet. Make sure to configure route table accordingly

  tags = merge(
    var.global_tags,
    {
      "Name"          = "nat",
      "resource_type" = "nat-gateway",
      "Creation Date" = "${timestamp()}"
    }
  )
}



# CONFIGURATION OF ENDPOINTS=============================
# Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.us-east-1.s3"
  route_table_ids   = [aws_route_table.public_rt.id, aws_route_table.private_rt.id]

  tags = merge(
    var.global_tags,
    {
      "Name"          = "s3",
      "resource_type" = "s3-endpoint",
      "Creation Date" = "${timestamp()}"
    }
  )
}
# SSM Endpoints
resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private_subnet[*].id #Ref all priv subnets dynamically
  security_group_ids = [aws_security_group.private_sg.id]

  tags = merge(
    var.global_tags,
    {
      "Name"          = "ssm_endpoint",
      "resource_type" = "ssm-endpoint",
      "Creation Date" = "${timestamp()}"
    }
  )
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private_subnet[*].id
  security_group_ids = [aws_security_group.private_sg.id]

  tags = merge(
    var.global_tags,
    {
      "Name"          = "ssmmessages",
      "resource_type" = "ssmmessages-endpoint",
      "Creation Date" = "${timestamp()}"
    }
  )
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.us-east-1.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private_subnet[*].id
  security_group_ids = [aws_security_group.private_sg.id]

  tags = merge(
    var.global_tags,
    {
      "Name"          = "ec2messages",
      "resource_type" = "ec2messages-endpoint",
      "Creation Date" = "${timestamp()}"
    }
  )
}