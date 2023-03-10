resource "aws_security_group" "omshree-node" {
  name        = "terraform-eks-omshree-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.omshree-vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    
     Name = "terraform-eks-omshree-node",
    # "kubernetes.io/cluster/${var.cluster-name}", "owned",
     owner = "omshree.butani@intuitive.cloud",

  }
}

resource "aws_security_group_rule" "omshree-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.omshree-node.id}"
  source_security_group_id = "${aws_security_group.omshree-node.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "omshree-node-ingress-cluster-https" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.omshree-node.id}"
  source_security_group_id = "${aws_security_group.omshree-cluster.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "omshree-node-ingress-cluster-others" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.omshree-node.id}"
  source_security_group_id = "${aws_security_group.omshree-cluster.id}"
  to_port                  = 65535
  type                     = "ingress"
}