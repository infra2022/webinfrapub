data "aws_availability_zones" "available" {}
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name    = "${var.project}-vpc"
    Project = var.project
  }
}

# resource "aws_subnet" "public_subnet_a" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.public_subnet_a_cidr
#   availability_zone = "${var.region}a"

#   tags = {
#     Name = "${var.project}-vpc-public_subnet_a"
#   }
# }
# resource "aws_subnet" "private_subnet_a" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.private_subnet_a_cidr
#   availability_zone = "${var.region}a"

#   tags = {
#     Name = "${var.project}-vpc-private_subnet_a"
#   }
# }
resource "aws_subnet" "public_subnets" {
  count                   = "${length(var.public_subnets_cidr)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_subnets_cidr[count.index]}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project}_vpc_public_subnet_${count.index}"
  }
}
resource "aws_subnet" "private_subnets" {
  count                   = "${length(var.private_subnets_cidr)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.private_subnets_cidr[count.index]}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project}_vpc_private_subnet_${count.index}"
  }
}
# resource "aws_subnet" "private_subnet_b" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.private_subnet_b_cidr
#   availability_zone = "${var.region}b"

#   tags = {
#     Name = "${var.project}-vpc-private_subnet_b"
#   }
# }
# resource "aws_subnet" "public_subnet_b" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.public_subnet_b_cidr
#   availability_zone = "${var.region}b"

#   tags = {
#     Name = "${var.project}-vpc-public_subnet_b"
#   }
# }
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-vpc-ig"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id            = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  #refault_route_table_id = aws_vpc.vpc.default_route_table_id
  tags = {
    Name = "Public Subnet RT"
  }
}
resource "aws_eip" "nat_ip" {
  vpc                       = true
  # network_interface         = aws_network_interface.multi-ip.id
  # associate_with_private_ip = "10.0.0.10"
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "Gateway NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.ig]
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Pvt Subnet RT"
  }
}
resource "aws_route_table_association" "private_assoc" {
  count          = "${length(var.private_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.private_subnets[*].id, count.index)}"
  # subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  # subnet_id      = aws_subnet.private_subnets.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "public_assoc" {
  count          = "${length(var.public_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public_subnets[*].id, count.index)}"
  # subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  # subnet_id      = aws_subnet.private_subnets.id
  route_table_id = aws_route_table.public_rt.id
}
# resource "aws_route_table_association" "private_b" {
#   subnet_id      = aws_subnet.private_subnet_b.id
#   route_table_id = aws_route_table.private_rt.id
# }
# resource "aws_route_table_association" "private_a" {
#   subnet_id      = aws_subnet.private_subnet_a.id
#   route_table_id = aws_route_table.private_rt.id
# }
# resource "aws_route_table_association" "public_a" {
#   subnet_id      = aws_subnet.public_subnet_a.id
#   route_table_id = aws_route_table.public_rt.id
# }
# resource "aws_route_table_association" "public_b" {
#   subnet_id      = aws_subnet.public_subnet_b.id
#   route_table_id = aws_route_table.public_rt.id
# }