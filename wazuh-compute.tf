data "aws_ami" "amzn_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-*"]
  }
}

resource "aws_key_pair" "tf_kp" {
  key_name   = "tf_kp"
  public_key = file("~/.ssh/ec2_kp.pub")
}

resource "aws_instance" "ec2_tf" {
  count                  = var.main_instance_count
  instance_type          = var.main_instance_type
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.tf_kp.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = aws_subnet.test_public_subnet[count.index].id
  user_data              = templatefile("./server-userdata.tpl", { new_hostname = "ubuntu-server" })

  root_block_device {
    volume_size = var.main_vol_size
  }

  tags = {
    Name = "ec2_tf-${random_id.test_node_id[count.index].dec}"
  }

  provisioner "local-exec" {
    command = "prinf '\n${self.public_ip}' >> aws_hosts"
  }

  depends_on = [aws_internet_gateway.test_igw]
}

resource "null_resource" "grafana_update" {
  count = var.main_instance_count
  provisioner "remote-exec" {
    inline = ["sudo apt upgrade -y grafana && touch upgrade.log && echo 'I updated Grafana' >> upgrade.log"]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/ec2_kp")
      host        = aws_instance.ec2_tf[count.index].public_ip
    }
  }
}
