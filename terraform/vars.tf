variable "amiName" {
  default = ""
}
variable "elastic_key_pair" {
  default = ""
}
variable "instance_type" {
  default = "t2.small"
}
variable "owners" {
        type = list(string)
        default = [""]
}
variable "security_group_id" {
  default = ""
}
variable "devops_vpc" {
  default = ""
}
variable "subnet_private1" {
  default = ""
}
variable "subnet_private2" {
  default = ""
}
variable "instance_count" {
  default = ""
}
