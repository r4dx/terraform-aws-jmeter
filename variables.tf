variable "aws_region" {}

variable "vpc_id" {
  description = "VPC ID wher the cluster will be created"
}

variable "subnet_ids" {
  description = "The list of subnet IDs where the cluster will be created. Master node will be created in teh first subnet mentioned in this list"
  type        = "list"
}

variable "aws_amis" {
  default = {
    "us-east-1" = "ami-6869aa05"
    "us-west-2" = "ami-7172b611"
  }
}

variable "availability_zones" {
  default = "us-east-1b,us-east-1a"
}

variable "slave_instance_type" {
  description = "Instance type for slave nodes"
  default = "t2.micro"
}

variable "master_instance_type" {
  description = "Instance type for master node"
  default = "t2.micro"
}

variable "slave_ssh_public_key_file" {
  description = "SSH public key filename for slave nodes"
  default = "ssh/slave.pub"
}

variable "master_ssh_public_key_file" {
  description = "SSH public key filename for master node"
  default = "ssh/master.pub"
}

variable "master_ssh_private_key_file" {
  description = "SSH private key filename for master node"
  default = "ssh/master"
}

variable "slave_asg_size" {
  description = "Amount of working nodes in ASG"
  default = "2"
}

variable "jmx_script_file" {
  description = "JMX Script to run on master"
}

variable "jmeter3_url" {
  description = "URL with jmeter archive"
  default = "http://apache-mirror.rbc.ru/pub/apache/jmeter/binaries/apache-jmeter-3.3.tgz" 
}
