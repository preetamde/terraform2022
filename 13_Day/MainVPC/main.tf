# create a VPC with 10.10.0.0/16
resource "aws_vpc" "mainvpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true #default false
  enable_dns_support = true 
  instance_tenancy = "default"
  tags = {
      Name = "mainvpc"
  }
}

/* creating public subnets 10.10.10.0 - 10.10.20.0 */
resource "aws_subnet" "zonea_public" {
  cidr_block = "10.10.10.0/24" # required
  vpc_id = aws_vpc.mainvpc.id # required
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true #default false
  tags = {
      Name = "Zone-2A-Public"
  }
}
resource "aws_subnet" "zoneb_public" {
  cidr_block = "10.10.11.0/24" # required
  vpc_id = aws_vpc.mainvpc.id # required
  map_public_ip_on_launch = true
  availability_zone = "us-east-2b"
  tags = {
    Name = "Zone-2B-Public"
  }
}
resource "aws_subnet" "zonec_public" {
  cidr_block = "10.10.12.0/24" # required
  vpc_id = aws_vpc.mainvpc.id #required
  map_public_ip_on_launch = true
  availability_zone = "us-east-2c"
  tags = {
      Name = "Zone-2C-Public"
  }
}

/* creating private subnets
10.10.50.0 - 10.10.60.0
*/
# Zone A
resource "aws_subnet" "zonea_appl" {
  cidr_block = "10.10.50.0/24"
  vpc_id = aws_vpc.mainvpc.id
  availability_zone = var.aws-az-2a
  map_public_ip_on_launch = false # is by default false and no need to define
  tags = {
      Name = "Zone-2A-App"
  }
}
# Zone B
resource "aws_subnet" "zoneb_appl" {
  cidr_block = "10.10.51.0/24"
  vpc_id = aws_vpc.mainvpc.id
  availability_zone = var.aws-az-2b
  map_public_ip_on_launch = false # is by default false and no need to define
  tags = {
      Name = "Zone-2B-App"
  }
}
# Zone C
resource "aws_subnet" "zonec_appl" {
  cidr_block = "10.10.52.0/24"
  vpc_id = aws_vpc.mainvpc.id
  availability_zone = var.aws-az-2c
  map_public_ip_on_launch = false # is by default false and no need to define
  tags = {
      Name = "Zone-2C-App"
  }
}

/* Internet Gateway*/
resource "aws_internet_gateway" "mainvpc_igw" {
  vpc_id = aws_vpc.mainvpc.id
  tags = {
    "Name" = "mainvpc-IGW"
  }
}

# create route tables
resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.mainvpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.mainvpc_igw.id
  }
  tags = {
    "Name" = "Internet Access"
  }
}

# associate route table with public subnets only
resource "aws_route_table_association" "zonea" {
  subnet_id = aws_subnet.zonea_public.id
  route_table_id = aws_route_table.internet.id
}
resource "aws_route_table_association" "zoneb" {
  subnet_id = aws_subnet.zoneb_public.id
  route_table_id = aws_route_table.internet.id
}
resource "aws_route_table_association" "zonec" {
  subnet_id = aws_subnet.zonec_public.id
  route_table_id = aws_route_table.internet.id
}