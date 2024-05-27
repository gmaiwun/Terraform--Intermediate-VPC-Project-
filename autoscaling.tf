resource "aws_launch_template" "public_lt" {
  name          = "public-lt"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.ami_key 
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
    tags = merge(
      var.global_tags,
      {
        "Name" = "public-lt"
        "resource_type"     = "instance",
        "Instance_Category" = "Public",
        "Creation Date"     = "${timestamp()}"
      }
    )
  }
}

resource "aws_autoscaling_group" "public_asg" {
  desired_capacity     = 2
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = aws_subnet.public_subnet[*].id
  launch_template {
    id      = aws_launch_template.public_lt.id
    version = "$Latest"
  }

tag {
    key                 = "Name"
    value               = "${format("%s-instance", aws_launch_template.public_lt.name)}"
    propagate_at_launch = true
  }

  tag {
    key                 = "resource_type"
    value               = "instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Instance_Category"
    value               = "auto-scaling"
    propagate_at_launch = true
  }

  tag {
    key                 = "cost-center"
    value               = var.global_tags["cost-center"]
    propagate_at_launch = true
  }

  tag {
    key                 = "project"
    value               = var.global_tags["project"]
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.global_tags["Environment"]
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = var.global_tags["Owner"]
    propagate_at_launch = true
  }

  tag {
    key                 = "Application"
    value               = var.global_tags["Application"]
    propagate_at_launch = true
  }

  tag {
    key                 = "Compliance"
    value               = var.global_tags["Compliance"]
    propagate_at_launch = true
  }

  tag {
    key                 = "Business Unit"
    value               = var.global_tags["Business Unit"]
    propagate_at_launch = true
  }

  tag {
    key                 = "Service"
    value               = var.global_tags["Service"]
    propagate_at_launch = true
  }

  tag {
    key                 = "Version"
    value               = var.global_tags["Version"]
    propagate_at_launch = true
  }

  tag {
    key                 = "Lifecycle"
    value               = var.global_tags["Lifecycle"]
    propagate_at_launch = true
  }

  tag {
    key                 = "Region"
    value               = var.global_tags["Region"]
    propagate_at_launch = true
  }

  tag {
    key                 = "VPC"
    value               = var.global_tags["VPC"]
    propagate_at_launch = true
  }


  health_check_type          = "EC2"
  health_check_grace_period  = 300
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.public_asg.name
  lb_target_group_arn    = aws_lb_target_group.public_tg.arn
}
