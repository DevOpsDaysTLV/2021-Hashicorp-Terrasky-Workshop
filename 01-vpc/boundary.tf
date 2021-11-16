resource "tls_private_key" "dodworkshop" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "dodworkshop"
  public_key = tls_private_key.dodworkshop.public_key_openssh
}

resource "aws_security_group_rule" "allow_inbound_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.vpc.default_security_group_id
}

resource "aws_security_group_rule" "allow_inbound_boundary" {
  type        = "ingress"
  from_port   = 9200
  to_port     = 9202
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.vpc.default_security_group_id
}


resource "aws_instance" "boundary" {
  ami                         = "ami-0f4224d9a9b088c71"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.vpc.default_security_group_id]
  key_name                    = aws_key_pair.generated_key.key_name
  tags = {
    Name = "Boundary for devopsdays"
  }
}
