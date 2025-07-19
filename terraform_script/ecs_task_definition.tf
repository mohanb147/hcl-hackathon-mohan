        resource "aws_ecs_task_definition" "web_task" {
          family                   = "web"
          network_mode             = "awsvpc"
          cpu                      = "256"
          memory                   = "512"
          execution_role_arn       = aws_iam_role.arn:aws:iam::539935451710:role/ecs_task_execution_role
          task_role_arn            = aws_iam_role.arn:aws:iam::539935451710:role/ecs_task_role
          requires_compatibilities = ["FARGATE"]

          container_definitions = jsonencode(
            {
              name      = "web"
              image     = "httpd:latest"
              cpu       = 256
              memory    = 512
              essential = true
              portMappings = 
                {
                  containerPort = 80
                  hostPort      = 80
                  protocol      = "tcp"
                }

            }
)
        }