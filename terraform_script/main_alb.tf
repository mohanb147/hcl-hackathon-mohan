resource "aws_lb" "hcl-hack" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_group.id]
  subnets           = ["aws_subnet.public_subnet.id", "aws_subnet.private_subnet.id"]
  enable_deletion_protection = true


  tags = {
    Environment = "production"
  }
}