resource "aws_security_group" "omshree-cluster" {
  name        = "terraform-eks-omshree-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.omshree-vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-omshree"
  }
}

# OPTIONAL: Allow inbound traffic from your local workstation external IP
#           to the Kubernetes.
resource "aws_security_group_rule" "omshree-cluster-ingress-workstation-https" {
  cidr_blocks       = ["10.3.2.4/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.omshree-cluster.id}"
  to_port           = 443
  type              = "ingress"
}