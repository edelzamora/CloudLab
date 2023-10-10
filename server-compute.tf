data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "cloudlab_kp" {
  key_name   = "cloudlab_kp"
  public_key = file(var.key_pair)
}

resource "aws_instance" "ec2_tf" {
  instance_type          = var.server_instance_type
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.cloud_kp.id
  vpc_security_group_ids = [aws_security_group.cloudlab_sg.id]
  subnet_id              = aws_subnet.dmz_subnet.id
  user_data              = templatefile("./server-userdata.tpl", { new_hostname = "ubuntu-server" })

  root_block_device {
    volume_size = var.server_vol_size
  }

  tags = {
    Name = "ubuntu server"
  }

  depends_on = [aws_internet_gateway.cloudlab_igw]
}
