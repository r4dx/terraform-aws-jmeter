resource "aws_instance" "jmeter-master-instance" {

  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.master_instance_type}"

  security_groups = [ "${aws_security_group.jmeter-sg.name}" ]
  key_name = "${aws_key_pair.jmeter-master-keypair.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.jmeter_master_iam_profile.name}"

  tags {
    Name = "jmeter-master"
  }

  connection {
    user = "ec2-user"
    private_key = "${file("${var.master_ssh_private_key_file}")}"
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo mkdir /jmeter-master",
      "mkdir ~/.aws",
      "sudo chown -R ec2-user /jmeter-master",
      "sudo pip install boto3"
    ]
  }

  provisioner "file" {
    source = "${path.module}/master_start.py"
    destination = "/jmeter-master/master_start.py"
  }

  provisioner "file" {
    source = "${var.jmx_script_file}"
    destination = "/jmeter-master/script.jmx"
  }

  provisioner "file" {
    content = <<EOF
[default]
region=${var.aws_region}
EOF
    destination = "~/.aws/config"
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

resource "aws_iam_instance_profile" "jmeter_master_iam_profile" {
    name = "jmeter_master_iam_profile"
    roles = ["${aws_iam_role.jmeter_master_iam_role.name}"]
}

resource "aws_iam_role" "jmeter_master_iam_role" {
    name = "jmeter_master_iam_role"
    path = "/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "jmeter_master_iam_role_attachment" {
    role = "${aws_iam_role.jmeter_master_iam_role.name}"
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

output "master_public_ip" {
	value = "${aws_instance.jmeter-master-instance.public_ip}"
}