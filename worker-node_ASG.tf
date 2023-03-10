data "aws_ami" "eks-worker" {
  filter {
    name   = "omshree_asg"
    values = ["amazon-eks-node-${aws_eks_cluster.omshree-cluster.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

data "aws_region" "current" {}

locals {
  omshree-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.omshree-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.omshree-cluster.certificate_authority.0.data}' '${var.cluster-name}'
USERDATA
}

resource "aws_launch_configuration" "omshree" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.omshree-node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "m4.large"
  name_prefix                 = "terraform-eks-omshree"
  security_groups             = ["${aws_security_group.omshree-node.id}"]
  user_data_base64            = "${base64encode(local.omshree-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "omshree-asg" {
  desired_capacity     = 2
  launch_configuration = "${aws_launch_configuration.omshree.id}"
  max_size             = 2
  min_size             = 1
  name                 = "terraform-eks-omshree"
  vpc_zone_identifier  = flatten(["${aws_subnet.omshree-subnet.*.id}"])

  tag {
    key                 = "Name"
    value               = "terraform-eks-omshree"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}