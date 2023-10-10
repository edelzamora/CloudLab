data "aws_ami" "image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

variable "server_kp" {
  type        = string
  description = "The path to the key pair you created for the server"
}

resource "aws_key_pair" "server_kp" {
  key_name   = "server_kp"
  public_key = file(var.server_kp)
}

resource "aws_instance" "web_server" {
  instance_type          = var.main_instance_type
  ami                    = data.aws_ami.image.id
  key_name               = aws_key_pair.server_kp.id
  vpc_security_group_ids = [aws_security_group.cloudlab_sg.id]
  subnet_id              = aws_subnet.dmz_subnet.id
  user_data              = templatefile("./server-userdata.tpl", { new_hostname = "web-server" })

  root_block_device {
    volume_size = var.main_vol_size
  }

  tags = {
    Name = "web_server"
  }

  depends_on = [aws_internet_gateway.cloudlab_igw]
}

output "server_public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "web server public IP address"
}

output "server_private_ip" {
  value       = aws_instance.web_server.private_ip
  description = "web server private IP address"
}
