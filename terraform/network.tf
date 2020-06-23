# vpcの定義
resource "aws_vpc" "chells_kitchen" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "chells_kitchen_terraform"
    } 
}

# パブリックサブネットの定義(マルチAZ)
resource "aws_subnet" "public_0" {
    vpc_id                  = aws_vpc.chells_kitchen.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "ap-northeast-1a"
    map_public_ip_on_launch = true
}
resource "aws_subnet" "public_1" {
    vpc_id                  = aws_vpc.chells_kitchen.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "ap-northeast-1c"
    map_public_ip_on_launch = true
}

# インターネットゲートウェイの定義
resource "aws_internet_gateway" "chells_kitchen" {
    vpc_id = aws_vpc.chells_kitchen.id
}

# ルートテーブルの定義
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.chells_kitchen.id
}

# ルートの定義
resource "aws_route" "public" {
    route_table_id          = aws_route_table.public.id
    gateway_id              = aws_internet_gateway.chells_kitchen.id
    destination_cidr_block  = "0.0.0.0/0"
}

# ルートテーブルの関連付け(マルチAZ)
resource "aws_route_table_association" "public_0" {
    subnet_id           = aws_subnet.public_0.id
    route_table_id      = aws_route_table.public.id
}
resource "aws_route_table_association" "public_1" {
    subnet_id           = aws_subnet.public_1.id
    route_table_id      = aws_route_table.public.id
}

# プライベートサブネットの定義(マルチAZ)
resource "aws_subnet" "private_0" {
    vpc_id                  = aws_vpc.chells_kitchen.id
    cidr_block              = "10.0.65.0/24"
    availability_zone       = "ap-northeast-1a"
    map_public_ip_on_launch = false
}
resource "aws_subnet" "private_1" {
    vpc_id                  = aws_vpc.chells_kitchen.id
    cidr_block              = "10.0.66.0/24"
    availability_zone       = "ap-northeast-1c"
    map_public_ip_on_launch = false
}

# プライベートルートテーブルとvpcとの関連付けの定義
resource "aws_route_table" "private_0" {
    vpc_id = aws_vpc.chells_kitchen.id
}
resource "aws_route_table" "private_1" {
    vpc_id = aws_vpc.chells_kitchen.id
}
# プライベートのルートの定義(マルチAZ)
resource "aws_route" "private_0" {
    route_table_id          = aws_route_table.private_0.id
    nat_gateway_id          = aws_nat_gateway.nat_gateway_0.id
    destination_cidr_block  = "0.0.0.0/0"
}
resource "aws_route" "private_1" {
    route_table_id          = aws_route_table.private_1.id
    nat_gateway_id          = aws_nat_gateway.nat_gateway_1.id
    destination_cidr_block  = "0.0.0.0/0"
}

# プライベートルートテーブルとサブネットの関連付けの定義(マルチAZ)
resource "aws_route_table_association" "private_0" {
    subnet_id       = aws_subnet.private_0.id
    route_table_id  = aws_route_table.private_0.id
}
resource "aws_route_table_association" "private_1" {
    subnet_id       = aws_subnet.private_1.id
    route_table_id  = aws_route_table.private_1.id
}


# EIPの定義(マルチAZ)
resource "aws_eip" "nat_gateway_0" {
    vpc           = true
    depends_on    = [aws_internet_gateway.chells_kitchen]
}
resource "aws_eip" "nat_gateway_1" {
    vpc           = true
    depends_on    = [aws_internet_gateway.chells_kitchen]
}


# NATゲートウェイの定義(マルチAZ)
resource "aws_nat_gateway" "nat_gateway_0" {
    allocation_id = aws_eip.nat_gateway_0.id
    subnet_id     = aws_subnet.public_0.id
    depends_on    = [aws_internet_gateway.chells_kitchen]
}
resource "aws_nat_gateway" "nat_gateway_1" {
    allocation_id = aws_eip.nat_gateway_1.id
    subnet_id     = aws_subnet.public_1.id
    depends_on    = [aws_internet_gateway.chells_kitchen]
}




