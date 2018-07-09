resource "aws_instance" "jmeter-master-instance" {

  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.master_instance_type}"
  subnet_id     = "${var.subnet_ids[0]}"
  key_name      = "${aws_key_pair.jmeter-master-keypair.key_name}"

  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.jmeter-sg.id}"]

  tags {
    Name = "jmeter-master"
  }

  connection {
    user = "ec2-user"
    private_key = "${file("${var.master_ssh_private_key_file}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y java-1.8.0",
      "sudo yum remove -y java-1.7.0-openjdk",
      "sudo mkdir /opt/jmeter",
      "sudo chown -R ec2-user /opt/jmeter",
      "cd /opt/jmeter/",
      "curl ${var.jmeter3_url} > /tmp/jMeter.tgz",
      "tar zxvf /tmp/jMeter.tgz -C /opt/jmeter --strip-components=1",
    ]
  }
}

resource "aws_key_pair" "jmeter-master-keypair" {
  key_name = "jmeter-master-keypair"
  public_key = "${file("${var.master_ssh_public_key_file}")}"
}

}


output "master_public_ip" {
	value = "${aws_instance.jmeter-master-instance.public_ip}"
}