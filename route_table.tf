# Creation of Public Route Table =============================================
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    var.global_tags,
    {
      "Name"          = "public_rt",
      "resource_type" = "route-table",
      "Creation Date" = "${timestamp()}"
    }
  )
}

# Public Route Table Associations

resource "aws_route_table_association" "public_rt_assoc" {
  count = length(var.avail_zones)

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}


# Creation of private Route Table ==========================================

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    var.global_tags,
    {
      "Name"          = "private_rt",
      "resource_type" = "route-table",
      "Creation Date" = "${timestamp()}"
    }
  )
}

# Private Route Table Associations
resource "aws_route_table_association" "private_rt_assoc" {
  count = length(var.avail_zones)

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
