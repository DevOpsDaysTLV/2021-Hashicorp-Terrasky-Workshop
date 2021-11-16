resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "dodworkshop"
  public_key = tls_private_key.example.public_key_openssh
}


resource "aws_instance" "web" {
  ami                         = "ami-0f4224d9a9b088c71"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = module.vpc.public_subnets
  key_name                    = aws_key_pair.generated_key.key_name


  tags = {
    Name = "Boundary for devopsdays"
  }
}
