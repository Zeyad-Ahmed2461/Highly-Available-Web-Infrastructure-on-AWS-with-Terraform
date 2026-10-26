resource "aws_launch_template" "app" {
  name_prefix   = "app-template-"
  image_id      = var.ami_id_asg
  instance_type = var.instance_type
  key_name      = aws_key_pair.ec2_key.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
  vpc_security_group_ids = [aws_security_group.HTTP_SG.id]
user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y python3
mkdir -p /var/www/html
echo "Hello, World from ASG $(hostname -f)" > /var/www/html/index.html
nohup python3 -m http.server 80 --directory /var/www/html &
EOF
)

 }

resource "aws_autoscaling_group" "app_asg" {
  name                      = "ASG"
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  min_size            = 1
  max_size            = 3
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.priv_subnet1.id, aws_subnet.priv_subnet2.id]
  target_group_arns   = [aws_lb_target_group.tg.arn]

  tag {
    key                 = "Name"
    value               = "ASG_Instance"
    propagate_at_launch = true
  }
}
