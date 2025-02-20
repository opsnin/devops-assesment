resource "aws_subnet" "public_subnets" {
  count             = var.num_public_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, ceil(log(var.num_public_subnets + var.num_private_subnets, 2)), count.index)
  availability_zone = "${data.aws_region.current.name}${var.region_azs[count.index]}"

  tags = merge(
    {
      Name = "${var.project_name}-public-${var.region_azs[count.index]}"
    },
    var.public_subnet_tags
  )
}

resource "aws_subnet" "private_subnets" {
  count             = var.num_private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, ceil(log(var.num_public_subnets + var.num_private_subnets, 2)), count.index + var.num_public_subnets)
  availability_zone = "${data.aws_region.current.name}${var.region_azs[count.index]}"

  tags = merge(
    {
      Name = "${var.project_name}-private-${var.region_azs[count.index]}"
    },
    var.private_subnet_tags
  )
}