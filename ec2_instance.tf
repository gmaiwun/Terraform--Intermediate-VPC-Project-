resource "aws_instance" "private_instance" {
  count = length(var.avail_zones)
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.private_subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name


  tags = merge(
    var.global_tags,
    {
      "Name"              = format("private-instance-%d", count.index + 1),
      "resource_type"     = "instance",
      "Instance_Category" = "private",
      "Creation Date"     = "${timestamp()}"
    }
  )

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
