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
    "us-west-2" = "ami-39d39d41"
  }
}

variable "slave_instance_type" {
  description = "Instance type for slave nodes"
  default     = "t2.micro"
}

variable "master_instance_type" {
  description = "Instance type for master node"
  default     = "t2.medium"
}

variable "slave_ssh_public_key_file" {
  description = "SSH public key filename for slave nodes"
}

variable "master_ssh_public_key_file" {
  description = "SSH public key filename for master node"
}

variable "master_ssh_private_key_file" {
  description = "SSH private key filename for master node"
}

variable "slave_asg_size" {
  description = "Amount of working nodes in ASG"
  default     = "2"
}

variable "jmeter3_url" {
  description = "URL with jmeter archive"
  default     = "http://apache.mirrors.spacedump.net/jmeter/binaries/apache-jmeter-4.0.tgz"
}
