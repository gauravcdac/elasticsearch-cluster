data "aws_ami" "elasticsearch_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.amiName]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = var.owners
}


resource "aws_instance" "elasticsearch" {
  count = "${var.instance_count}"
  ami = data.aws_ami.elasticsearch_ami.id
  instance_type = var.instance_type
  subnet_id = var.subnet_private2
  security_groups = [
    var.security_group_id]
  key_name = var.elastic_key_pair
  tags = {
    Name = "ElastucSearchServer"
  }

  provisioner "remote-exec" {
    inline = [
                "pwd",
                "sudo wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.1-linux-x86_64.tar.gz",
                "sudo tar -xvf elasticsearch-7.9.1-linux-x86_64.tar.gz -C /opt/",
                "sudo useradd -m -p elasticsearch elasticsearch"
             ]

  provisioner "local-exec" {
    command = <<EOT
        echo "[${var.os}_${count.index}]" >> hosts
        echo "${self.private_ip}" >> hosts
        echo "" >> hosts
    EOT
  }

  connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("Elastic-KeyPair.pem")
      host        = aws_instance.elasticsearch.private_ip
}
}
}

output "elasticsearch" {
  value = aws_instance.elasticsearch.private_ip
}
