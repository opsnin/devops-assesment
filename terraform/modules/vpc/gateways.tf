locals {
  nat_gateway_count = var.single_nat_gateway ? 1 : var.num_private_subnets
}

resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-public-igw"
  }
}

resource "aws_eip" "nat_gw_ips" {
  count = local.nat_gateway_count

  tags = {
    Name = var.single_nat_gateway ? "${var.project_name}-private-nat-gw-ip" : "${var.project_name}-private-nat-gw-ip-${var.region_azs[count.index]}"

  }
}

resource "aws_nat_gateway" "private_nat_gws" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.nat_gw_ips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = var.single_nat_gateway ? "${var.project_name}-nat-gw" : "${var.project_name}-nat-gw-${var.region_azs[count.index]}"

  }
  depends_on = [aws_internet_gateway.public_igw]
}
