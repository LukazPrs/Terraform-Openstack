variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/pHfa2nc2UayVdAQBF7OZcWwva2JP3oXJAWE1Xf2h54i42rWoLEkoRIMf0J68Yv1toQZ9epZepStmmmalc61hadOju9Y+/HE4+aw15qYDOW+q2JBtp22tITXU419ioZAnUgxwBVNKf3BR7g0y7p8Bky1rZQI+TrriSAA+VgC9uwzEcC3sB00nORhZ28DrJlo6XpS0XK2NfyVD5zVxw7LVyjk7lZp99UXaXDzKcgeXDOe0k+ePCCf5nBJ962Chy1NtxX54zK7pUD8DV+pPusVneV9i/uRKEEsvdNieqAxBfOKrhONBs37GUZoVVsp9pG9XLKkYMTaizTczJ7ts7mwsd39AHjac2p2nlMUxKw5vA+l+Tp2Y8RokWn7gyZSHZcp0CgrlAatJxniyiEkGRNwZ+2UOFXH1xSWlXxI/DHqQ44+dpq8TUKhmLQo/voYNcBJyI4kpOHkoUAoNHqoMTMDQnUfWSOzti36C25J7DhjMPcCkgkpC17BvD0+Wg/sM1ps= lucas@risc-Inspiron-7460"
}

variable "provider_user" {
  type = string
  description = "usuário do provider"
}

variable "provider_tenant" {
  type = string
  description = "tenant do provider"
}

variable "provider_pass" {
  type = string
  description = "senha do provider"
}