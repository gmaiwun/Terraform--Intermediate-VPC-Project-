resource "aws_instance" "private_instance_1" {
  ami = "ami-08d4ac5b634553e16"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  tags = {
    Name = "private-instance-1"
  }
  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y awscli
              sudo apt-get install -y amazon-ssm-agent
              sudo systemctl start amazon-ssm-agent
              sudo systemctl enable amazon-ssm-agent
              EOF
  )
}

# For Private Instance-2

resource "aws_instance" "private_instance_2" {
  ami = "ami-08d4ac5b634553e16"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private_subnet_2.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  tags = {
    Name = "private-instance-2"
  }
  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y awscli
              sudo apt-get install -y amazon-ssm-agent
              sudo systemctl start amazon-ssm-agent
              sudo systemctl enable amazon-ssm-agent
              EOF
  )
}