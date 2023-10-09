variable "region" {
  type        = string
  description = "Choose the AWS region to deploy resources i.e us-east-1, us-west-1, us-west-2, us-east-2"
}

variable "vpc_cidr" {
  type        = string
  description = "Input a CIDR Range for the VPC: MAX CIDR /16"
}

# Simulated internet subnet
variable "sim_internet_cidr" {
  type        = string
  description = "Input a CIDR Range for the simulated internet subnet: within the VPC CIDR Range"
}

# DMZ subnet
variable "dmz_cidr" {
  type        = string
  description = "Input a CIDR Range for the DMZ: within the VPC CIDR Range"
}

# On-premises subnet
variable "on_prem_cidr" {
  type        = string
  description = "Input a CIDR Range for the On-Prem: within the VPC CIDR Range"
}

variable "public_ip" {
  type = string
  description = "Your public IP address from where you are connected to OR 0.0.0.0/32 (Not recommended, always internet wide access); home ip or on Google look up 'what is my ip' \n Add a /32 at the end; 1.2.3.4/32"
}

