resource "aws_instance" "jmeter-master-instance" {

  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.master_instance_type}"

  security_groups = [ "${aws_security_group.jmeter-sg.name}" ]
  key_name = "${aws_key_pair.jmeter-master-keypair.key_name}"

  tags {
    Name = "jmeter-master"
  }

  connection {
    user = "ec2-user"
    private_key = "${file("${var.master_ssh_private_key_file}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /jmeter-master/",
      "curl ${var.jmeter3_url} > jMeter.tgz",
      "tar zxvf jMeter.tgz"
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