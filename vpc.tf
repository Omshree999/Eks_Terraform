
resource "aws_vpc" "omshree-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
   
     Name = "terraform-eks-omshree-node"
     #kubernetes.io/cluster/cluster_omshree = "shared"
     owner = "omshree.butani@intuitive.cloud"

}
}

resource "aws_subnet" "omshree-subnet" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.omshree-vpc.id}"

  tags = {

     Name = "terraform-eks-omshree-node"
     #kubernetes.io/cluster/cluster_omshree = "shared"
     owner = "omshree.butani@intuitive.cloud"
}
}

resource "aws_internet_gateway" "omshree-igw" {
  vpc_id = "${aws_vpc.omshree-vpc.id}"

  tags = {
    owner = "omshree.butani@intuitive.cloud"
  }
}

resource "aws_route_table" "omshree-rt" {
  vpc_id = "${aws_vpc.omshree-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.omshree-igw.id}"
  }
}

resource "aws_route_table_association" "omshree-rta" {
  count = 2

  subnet_id      = "${aws_subnet.omshree-subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.omshree-rt.id}"
}