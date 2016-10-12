resource "aws_autoscaling_group" "jmeter-slave-ASG" {
  availability_zones = ["${split(",", var.availability_zones)}"]

  name = "jmeter-slave-ASG"
  max_size = "${var.slave_asg_size}"
  min_size = "${var.slave_asg_size}"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.jmeter-slave-lc.name}"

  tag {
    key = "Name"
    value = "jmeter-slave"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "jmeter-slave-lc" {
  name = "jmeter-slave-lc"
  image_id = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.slave_instance_type}"
  user_data = <<EOF
#!/bin/sh
curl ${var.jmeter3_url} > jMeter.tgz
tar zxvf jMeter.tgz
apache-jmeter-3.0/bin/jmeter-server
EOF

  security_groups = ["${aws_security_group.jmeter-sg.id}"]
  key_name = "${aws_key_pair.jmeter-slave-keypair.key_name}"
}

resource "aws_key_pair" "jmeter-slave-keypair" {
  key_name = "jmeter-slave-keypair"
  public_key = "${file("${var.slave_ssh_public_key_file}")}"
}