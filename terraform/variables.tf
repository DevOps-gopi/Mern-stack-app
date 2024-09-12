variable "region" {
  default = "us-east-1"
  type    = string
}
variable "cluster-name" {
  type = string
}

variable "eks_version" {}

variable "cidr" {}

variable "private_subnet_cidr" {
  type = list(string)
}
variable "public_subnet_cidr" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "addons" {

  default = [
    {
      name        = "coredns"
      add_version = "v1.11.1-eksbuild.11"
    },
    {
      name        = "vpc-cni"
      add_version = "v1.18.3-eksbuild.2"
    },
    {
      name        = "kube-proxy"
      add_version = "v1.30.3-eksbuild.5"
    },
    {
      name        = "aws-ebs-csi-driver"
      add_version = "v1.30.0-eksbuild.1"
    },

  ]
}