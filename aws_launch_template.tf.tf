data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "ecs_ec2" {
  name_prefix   = "cluster-bia-web-"
  image_id      = data.aws_ssm_parameter.ecs_optimized_ami.value
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.subnet1.id
    security_groups             = [aws_security_group.SG1.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name     = "${var.tag_name}-launch"
      App      = "${var.tag_app}-launch"
      Servico  = "${var.tag_servico}-launch"
    }
  }

  iam_instance_profile {
    name = "role-acesso-ssm"
  }

  user_data = base64encode(<<EOF
  #!/bin/bash
  echo ECS_CLUSTER=${aws_ecs_cluster.cluster-todo.name} >> /etc/ecs/ecs.config
  EOF
  )
}

resource "null_resource" "set_default_version" {
  provisioner "local-exec" {
    command = <<EOT
      aws ec2 modify-launch-template --launch-template-id ${aws_launch_template.ecs_ec2.id} --default-version ${aws_launch_template.ecs_ec2.latest_version}
    EOT
  }
  depends_on = [aws_launch_template.ecs_ec2]
}