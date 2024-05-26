resource "aws_launch_template" "public_lt" {
  name          = "public-lt"
  image_id      = "ami-08d4ac5b634553e16"
  instance_type = "t2.micro"
  key_name      = "terraform_keys" #Use own keys
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
  network_interfaces {
    security_groups = [aws_security_group.public_sg.id]
    associate_public_ip_address = true
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
              echo "Hello, World! I am learning Terraform and I love it" | sudo tee /var/www/html/index.html
              sudo apt-get install -y awscli
              sudo apt-get install -y amazon-ssm-agent
              sudo systemctl start amazon-ssm-agent
              sudo systemctl enable amazon-ssm-agent
              EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "public-instance"
    }
  }
}

resource "aws_autoscaling_group" "public_asg" {
  desired_capacity     = 2
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  launch_template {
    id      = aws_launch_template.public_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "public-asg-instance"
    propagate_at_launch = true
  }

  health_check_type          = "EC2"
  health_check_grace_period  = 300
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.public_asg.name
  lb_target_group_arn    = aws_lb_target_group.public_tg.arn
}
