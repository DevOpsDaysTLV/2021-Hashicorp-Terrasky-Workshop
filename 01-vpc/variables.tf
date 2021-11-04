variable "name" {
  type    = string
  default = "devopsdaystlv2021"
}
variable "public_subnets" {
  type = list(any)
  default = [
    "10.0.20.0/24",
    "10.0.21.0/24",
    "10.0.22.0/24",
  ]
}
variable "cidr" {
  default = "10.0.0.0/16"
}
