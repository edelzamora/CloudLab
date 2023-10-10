variable "parrot_kp" {
  type        = string
  description = "The path to the key pair you created for the parrot instance"
}

resource "aws_key_pair" "parrot_kp" {
  key_name   = "parrot_kp"
  public_key = file(var.parrot_kp)
}

resource "aws_instance" "parrot_attackbox" {
  instance_type          = var.main_instance_type
  ami                    = data.aws_ami.image.id
  key_name               = aws_key_pair.parrot_kp.id
  vpc_security_group_ids = [aws_security_group.cloudlab_sg.id]
  subnet_id              = aws_subnet.sim_internet_subnet.id
  user_data              = templatefile("./parrot-userdata.tpl", { new_hostname = "parrot-attackbox" })

  root_block_device {
    volume_size = var.main_vol_size
  }

  tags = {
    Name = "parrot_attackbox"
  }

  depends_on = [aws_internet_gateway.cloudlab_igw]
}

output "parrot_private_ip" {
  value       = aws_instance.parrot_attackbox.private_ip
  description = "parrot instance private IP address"
}
