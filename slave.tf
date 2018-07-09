resource "aws_autoscaling_group" "jmeter-slave-ASG" {
  name                 = "jmeter-slave-ASG"
  max_size             = "${var.slave_asg_size}"
  min_size             = "${var.slave_asg_size}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.jmeter-slave-lc.name}"
  vpc_zone_identifier  = "${var.subnet_ids}"

  tag {
    key                 = "Name"
    value               = "jmeter-slave"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "jmeter-slave-lc" {
  name_prefix   = "jmeter-slave-lc"
  image_id      = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.slave_instance_type}"

  user_data = <<EOF
#!/bin/sh
sudo yum install -y java-1.8.0
sudo yum remove -y java-1.7.0-openjdk
sudo mkdir /opt/jmeter
sudo chown -R ec2-user /opt/jmeter-master
curl ${var.jmeter3_url} > /tmp/jMeter.tgz
tar zxvf /tmp/jMeter.tgz -C /opt/jmeter --strip-components=1
nohup /opt/jmeter/bin/jmeter-server &
EOF

  # associate_public_ip_address = false
  security_groups = ["${aws_security_group.jmeter-sg.id}"]
  key_name        = "${aws_key_pair.jmeter-slave-keypair.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "jmeter-slave-keypair" {
  key_name   = "jmeter-slave-keypair"
  public_key = "${file("${var.slave_ssh_public_key_file}")}"
}

# Collect IPs of slaves
data "aws_instances" "slaves" {
  instance_tags {
    Name = "jmeter-slave"
  }

  depends_on = ["aws_autoscaling_group.jmeter-slave-ASG"]
}

output "slave_public_ips" {
  value = "${data.aws_instances.slaves.public_ips}"
}

output "slave_private_ips" {
  value = "${data.aws_instances.slaves.private_ips}"
}
