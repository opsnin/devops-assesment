resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project_name}-rt-public"
    Subnet_Type = "public"
  }
}

resource "aws_route_table" "private_route_table" {
  count = local.nat_gateway_count

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = var.single_nat_gateway ? "${var.project_name}-rt-private" : "${var.project_name}-rt-private-${var.region_azs[count.index]}"
    Subnet_Type = "private"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count     = var.num_public_subnets
  subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = element(
    aws_route_table.public_route_table[*].id,
    var.single_nat_gateway ? 0 : count.index
  )
}

resource "aws_route_table_association" "private_rt_assoc" {
  count = var.num_private_subnets

  subnet_id = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = element(
    aws_route_table.private_route_table[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_route" "prod_rt_public_egress" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_igw.id
}

resource "aws_route" "prod_rt_private_egress" {
  count                  = local.nat_gateway_count
  route_table_id         = aws_route_table.private_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.private_nat_gws[count.index].id
}
