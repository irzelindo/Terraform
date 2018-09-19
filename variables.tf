variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-west-2"
}

variable "access_key" {
  description = "The aws access key."
  default     = ""
}

variable "secret_key" {
  description = "The aws secret key."
  default     = ""
}

variable "pem_key" {
  default     = "udacity_student"
  description = "ssh key for EC2 machines"
}

variable "ami_type" {
  default     = "ami-ba602bc2"
  description = "Ubuntu Server 16.04 LTS (HVM), SSD Volume Type for the Oregon Region"
}

variable "random_s3_name" {
  description = "Generate random bucket name for code scalability"
  default     = "server-files-bucket"
}

variable "DNS_Zone" {
  default     = "p2.internal"
  description = "set dns name"
}

variable "vpc-fullcidr" {
  default     = "10.0.0.0/16"
  description = "the vpc cdir"
}

variable "Public-subnet-server-a-CIDR" {
  default     = "10.0.1.0/24"
  description = "Webserver zone a public subnet"
}

variable "Public-subnet-server-b-CIDR" {
  default     = "10.0.2.0/24"
  description = "Webserver zone c public subnet"
}

variable "Private-subnet-DBa-CIDR" {
  default     = "10.0.3.0/24"
  description = "DB private subnet"
}

variable "Private-subnet-DBb-CIDR" {
  default     = "10.0.4.0/24"
  description = "DB private subnet"
}

variable "Public-subnet-bastion-a-CIDR" {
  default     = "10.0.5.0/24"
  description = "Bastion public subnet"
}

variable "Public-subnet-bastion-b-CIDR" {
  default     = "10.0.6.0/24"
  description = "Bastion public subnet"
}

// Output variables

output "Load balance endpoint" {
  value = "${aws_lb.project_lb.dns_name}"
}

output "Zone A Bastion" {
  value = "${aws_instance.bastion_server_a.public_dns}"
}

output "Zone B Bastion" {
  value = "${aws_instance.bastion_server_b.public_dns}"
}

output "Webserver A address" {
  value = "${aws_instance.project_webserver_a.private_ip}"
}

output "Webserver B address" {
  value = "${aws_instance.project_webserver_b.private_ip }"
}
