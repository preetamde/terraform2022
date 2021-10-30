# * Pull VPC, Public and private subnet from the AWS
data "aws_vpc" "mainvpc" {
  cidr_block = "10.10.0.0/16"
}
data "aws_subnet" "zonea_public" {
  cidr_block = "10.10.10.0/24"
}

data "aws_subnet" "privatezonea" {
  cidr_block = "10.10.50.0/24"
}
data "aws_subnet" "privatezoneb" {
  cidr_block = "10.10.51.0/24"
}
data "aws_subnet" "privatezonec" {
  cidr_block = "10.10.52.0/24"
}
# EIP for NATGW
resource "aws_eip" "eipnatgw" {
  vpc = true
}

# * deploy NAT GW

resource "aws_nat_gateway" "natgw" {
    allocation_id = aws_eip.eipnatgw.id
    subnet_id = data.aws_subnet.zonea_public.id
    tags = {
      "Name" = "NATGW-ZoneA"
    }
}

# create route table
resource "aws_route_table" "privateinternetaccess" {
  vpc_id = data.aws_vpc.mainvpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    "Name" = "Priv-Internet"
  }
}

# associate route table with private subnets
resource "aws_route_table_association" "zoneaprivate" {
  subnet_id = data.aws_subnet.privatezonea.id
  route_table_id = aws_route_table.privateinternetaccess.id
}

resource "aws_route_table_association" "zonebprivate" {
  subnet_id = data.aws_subnet.privatezoneb.id
  route_table_id = aws_route_table.privateinternetaccess.id
}

resource "aws_route_table_association" "zonecprivate" {
  subnet_id = data.aws_subnet.privatezonec.id
  route_table_id = aws_route_table.privateinternetaccess.id
}