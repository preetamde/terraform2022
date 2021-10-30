module "vpc_dev" {
source = "./vpc_dev"
name = "dev"
cidr = "10.11.0.0/16"
public_subnet_a = "10.11.11.0/24"
public_subnet_b = "10.11.12.0/24"
}
#create two instances, refer to count
resource "aws_instance" "web" {
  ami = lookup(var.ami, var.region)
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = module.vpc_dev.public_subnet_id_a
  user_data = file("webserver.sh")
  vpc_security_group_ids = [ aws_security_group.web-sg.id ]
  count = 2 # newly introduced first time
  tags = {
    "Name" = "Apache2-${format("%03d",count.index+1)}"
  }
}
#security group for webservers
resource "aws_security_group" "web-sg" {
  name = "webservices-sg"
  vpc_id = module.vpc_dev.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [ aws_security_group.lb-sg.id ]
    #cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow access from LB"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow outgoing for internet"
  }
  tags = {
    "Name" = "web-sg"
  }
}

#security group for Load Balancer
resource "aws_security_group" "lb-sg" {
  name = "lbservices-sg"
  vpc_id = module.vpc_dev.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow access from internet"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow outgoing"
  }
  tags = {
    "Name" = "lbsvc-sg"
  }
}
# Lets start with load balancer
resource "aws_lb" "app-lb" {
  name = "app-lb-svc"
  load_balancer_type = "application"
  security_groups = [ aws_security_group.lb-sg.id ]
  subnets = [ module.vpc_dev.public_subnet_id_a, module.vpc_dev.public_subnet_id_b ]

  tags = {
    "Name" = "development-LB"
  }
}
resource "aws_lb_target_group" "websvc-tg" {
  name = "TG-for-WebServers"
  port = 80
  protocol = "HTTP"
  vpc_id = module.vpc_dev.vpc_id
  load_balancing_algorithm_type = "round_robin" #default
  target_type = "instance" #default
  health_check {
    enabled = true
    interval = 5 # every 5 seconds it will check
    path = "/healthcheck.html"
    port = 80
    protocol = "HTTP" # defaults
    timeout = 2 #default
  }
  tags = {
    "Name" = "Target Group for Webservers"
  }
}
# LB Target group
resource "aws_lb_target_group_attachment" "websvc-tg-attach" {
  target_group_arn = aws_lb_target_group.websvc-tg.arn
  count = length(aws_instance.web)
  target_id = aws_instance.web[count.index].id # need to fill in
  port = 80
}
# Listener 
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.app-lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.websvc-tg.arn
  }
}
# Listener Rule
resource "aws_lb_listener_rule" "rule" {
  listener_arn = aws_lb_listener.front_end.arn
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.websvc-tg.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}