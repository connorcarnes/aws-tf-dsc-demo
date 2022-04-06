resource "aws_key_pair" "this" {
  key_name   = "${var.name_prefix}-tf-lab"
  public_key = file(var.key_path)
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Default route required for the VPC to push traffic via gateway
resource "aws_route" "igw" {
  route_table_id         = aws_vpc.this.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Gateway which allows outbound and inbound internet access to the VPC
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_subnet" "public" {
  count = length(var.subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = join("-", ["tf-lab-subnet", "${count.index}"])
  }
}

resource "aws_vpc_dhcp_options" "this" {
  domain_name          = "first.local"
  domain_name_servers  = flatten([var.pdc_ip, var.dns_ips])
  ntp_servers          = [var.pdc_ip]
  netbios_name_servers = [var.pdc_ip]
  netbios_node_type    = 2
}

resource "aws_vpc_dhcp_options_association" "this" {
  vpc_id          = aws_vpc.this.id
  dhcp_options_id = aws_vpc_dhcp_options.this.id
}
resource "aws_security_group" "this" {
  vpc_id = aws_vpc.this.id

  ingress {
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
    from_port   = 0
    to_port     = 0
    description = "Allow traffic from VPC"
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = var.management_ips
    from_port   = 3389
    to_port     = 3389
    description = "Allow RDP from management IPs."
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = var.management_ips
    from_port   = 22
    to_port     = 22
    description = "Allow SSH from management IPs."
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = var.management_ips
    from_port   = 5985
    to_port     = 5986
    description = "Allow WinRM from management IPs."
  }

  # Allow global outbound
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_security_group" "block_all" {
  vpc_id = aws_vpc.this.id
}