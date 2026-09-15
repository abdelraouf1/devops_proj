variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "networkat-nat"
}

variable "public_key" {
  type = string
}
variable "cidr_block" {
    type = string
    default = "10.0.0.0/16"
  
}