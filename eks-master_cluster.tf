resource "aws_eks_cluster" "omshree-cluster" {
  name            = "${var.cluster-name}"
  role_arn        = "${aws_iam_role.omshree-cluster.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.omshree-cluster.id}"]
    subnet_ids         = flatten(["${aws_subnet.omshree-subnet.*.id}"])
  }

  depends_on = [
    "aws_iam_role_policy_attachment.omshree-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.omshree-cluster-AmazonEKSServicePolicy",
  ]
}