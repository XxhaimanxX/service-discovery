resource "aws_instance" "consul_server" {

  ami           = lookup(var.ami, var.region)
  count         = 3
  instance_type = "t2.micro"
  key_name      = var.opsschool-key-pair
  subnet_id                   = aws_subnet.public.id
  iam_instance_profile   = data.aws_iam_instance_profile.consul-join.name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.opsschool_consul.id]
  user_data            = file("scripts/consul-server.sh")

  tags = {
    Name = "opsschool-server"
    consul_server = "true"
  }
}

resource "aws_instance" "consul_agent" {

  ami           = lookup(var.ami, var.region)
  instance_type = "t2.micro"
  key_name      = var.opsschool-key-pair
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile   = data.aws_iam_instance_profile.consul-join.name
  vpc_security_group_ids = [aws_security_group.opsschool_consul.id]
  user_data            = file("scripts/consul-agent.sh")

  tags = {
    Name = "opsschool-agent"
  }
}