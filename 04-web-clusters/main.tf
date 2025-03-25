# Configure the AWS provider
provider "aws" {
  region = "eu-west-1"
}

# Data source: query the list of availability zones
data "aws_availability_zones" "all" {}

# Create a Security Group for an EC2 instance
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  
  ingress {
    from_port	  = "${var.server_port}"
    to_port		  = "${var.server_port}"
    protocol	  = "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create a Security Group for an ELB
resource "aws_security_group" "elb" {
  name = "terraform-example-elb"
  
  ingress {
    from_port	  = 80
	  to_port		  = 80
	  protocol	  = "tcp"
	  cidr_blocks	= ["0.0.0.0/0"]
  }

  egress {
    from_port	  = 0
	  to_port		  = 0
	  protocol	  = "-1"
	  cidr_blocks	= ["0.0.0.0/0"]
  }
}

# Create a Launch template
resource "aws_launch_template" "example" {
  name          = "example-launch-template"
  image_id      = "ami-785db401"  # Use a valid AMI ID
  instance_type = "t2.micro"

  security_group_names = [aws_security_group.instance.name]

  # User data script (base64 encoded to avoid issues)
  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "Hello, World" > index.html
    nohup busybox httpd -f -p "${var.server_port}" &
  EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}




# Create an Autoscaling Group
resource "aws_autoscaling_group" "example" {
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  availability_zones = data.aws_availability_zones.all.names  # Use appropriate availability zones

  load_balancers = [aws_elb.example.name]  # Reference the load balancer (if applicable)
  health_check_type = "ELB"  # You can adjust based on your health check needs

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}


# Create an ELB
resource "aws_elb" "example" {
  name               = "terraform-asg-example"
  availability_zones = data.aws_availability_zones.all.names
  security_groups    = ["${aws_security_group.elb.id}"]
  
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }
  
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.server_port}/"
  }
}
