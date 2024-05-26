# Security Group for Public Instances

resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public_sg"
  }
  
}

# Creation of private security group

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main.id

# Necessary for SSM to work. 
# Note that secured connection is necessary for SSM since it is outside the vpc
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Enables outbound communications ntom be possible
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



  tags = {
    Name = "private_sg"
  }
}

# Private Security from public instances to S3

resource "aws_security_group_rule" "allow_public_to_s3" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  source_security_group_id = aws_security_group.public_sg.id
  security_group_id = aws_security_group.public_sg.id
}

# Private Security from private instances to S3

resource "aws_security_group_rule" "allow_private_to_s3" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  source_security_group_id = aws_security_group.private_sg.id
  security_group_id = aws_security_group.private_sg.id
}