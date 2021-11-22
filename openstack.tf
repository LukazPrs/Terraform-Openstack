terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "1.45.0"
    }
  }
}

######## CRIANDO RECURSOS BASICOS PARA INICIO DE CONSUMO DE RECURSOS
## [flavors, networks, subnets, images etc.]

# CRIANDO FLAVORS [1 = cirros, 2 = Medio, 3 = Intermediario]
resource "openstack_compute_flavor_v2" "flavor-cirros" {
  name  = "flavor_cirros"
  ram   = "128"
  vcpus = "1"
  disk  = "1"
  is_public = true
  flavor_id = 1

  # extra_specs = {
  #   "hw:cpu_policy"        = "CPU-POLICY",
  #   "hw:cpu_thread_policy" = "CPU-THREAD-POLICY"
  # }
}

resource "openstack_compute_flavor_v2" "flavor-medio" {
  name  = "flavor_medio"
  ram   = "2048"
  vcpus = "2"
  disk  = "8"
  is_public = true
  flavor_id = 2
}
resource "openstack_compute_flavor_v2" "flavor-intermediario" {
  name  = "flavor_intermediario"
  ram   = "4096"
  vcpus = "3"
  disk  = "10"
  is_public = true
  flavor_id = 3
}

######## CRIANDO REDE PRIVADA(vxlan) [192.168.100.X] & PUBLICA(DMZ) [192.168.30.X] COM SUBNETS

# criando rede privada
resource "openstack_networking_network_v2" "rede-100" {
  name           = "rede100"
#  admin_state_up = "true"
}

# criando subnet para rede100
resource "openstack_networking_subnet_v2" "subnet-100" {
  name       = "subnet_100"
  network_id = "${openstack_networking_network_v2.rede-100.id}"
  cidr       = "192.168.100.0/24"
  ip_version = 4

  allocation_pool {
    start = "192.168.100.2"
    end   = "192.168.100.12"
  }  
}

### criando rede publica(type flat) | TESTAR
resource "openstack_networking_network_v2" "externa" {
  name           = "rede-externa"
  admin_state_up = "true"
  external       = true
#  tenant_id      = 
  segments {
    physical_network = "physnet1"
    network_type = "flat"
  }

}
# Sub-rede publica
resource "openstack_networking_subnet_v2" "subnet-publica" {
  name       = "subnet_publica"
  network_id = "${openstack_networking_network_v2.externa.id}"
  cidr       = "192.168.30.0/24"
  ip_version = 4
  dns_nameservers = ["8.8.8.8","8.8.4.4"]

  allocation_pool {
    start = "192.168.30.80"
    end   = "192.168.30.99"
  }  
}

## Criando security group (secgroup-start)
resource "openstack_compute_secgroup_v2" "secgroup_start" {
  name        = "secgroup-start"
  description = "primeiro security group"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
}

# CRIANDO ROUTER 
resource "openstack_networking_router_v2" "router" {
  name                = "router"
  admin_state_up      = true
  external_network_id = "${openstack_networking_network_v2.externa.id}"
  enable_snat         = true
}
resource "openstack_networking_router_interface_v2" "conect-internal" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet-100.id}"
}

## Baixando imagem do UBUNTU21
resource "openstack_images_image_v2" "ubuntu" {
  name             = "ubuntu21"
  image_source_url = "https://cloud-images.ubuntu.com/hirsute/current/hirsute-server-cloudimg-amd64.img"
  container_format = "bare"
  disk_format      = "qcow2"
  visibility       = "public"
}

resource "openstack_compute_instance_v2" "ubuntu" {
  name            = "ubuntu21"
  flavor_id       = "2"
  key_pair        = "minha_chave"
  security_groups = ["secgroup-start"]

  block_device {
    uuid                  = "${openstack_images_image_v2.ubuntu.id}"
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
    volume_size           = 8    
  }

  network {
    name = "rede100"
  }
}


### Baixando imagem do CIRROS
resource "openstack_images_image_v2" "cirros" {
  name             = "cirros"
  image_source_url = "http://download.cirros-cloud.net/0.5.1/cirros-0.5.1-x86_64-disk.img"
  container_format = "bare"
  disk_format      = "qcow2"
  visibility       = "public"
}

### ADICIONANDO KEYPAIR NO OPENSTACK(minha_chave)
resource "openstack_compute_keypair_v2" "minha-chave" {
  name       = "minha_chave"
  public_key = var.ssh_key
}

# ### CRIANDO INSTANCE PARA TESTE (criando volume com block_device)
resource "openstack_compute_instance_v2" "cirros" {
  name            = "cirros1"
#  image_id        = "${openstack_images_image_v2.cirros.id}"
  flavor_id       = "1"
  key_pair        = "minha_chave"
  security_groups = ["secgroup-start"]

  block_device {
    uuid                  = "${openstack_images_image_v2.cirros.id}"
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
    volume_size           = 1
  }

  network {
    name = "rede100"
  }
}

### ADICIONANDO VOLUME PARA SER ADICIONADO NA INSTANCIA cirros1 E ATTACH VOLUME
resource "openstack_blockstorage_volume_v3" "volume-cirros" {
  name = "volume-cirros1"
  size = 3
  volume_type = "__DEFAULT__"
}

resource "openstack_compute_volume_attach_v2" "volume-attach" {
  instance_id = "${openstack_compute_instance_v2.cirros.id}"
  volume_id   = "${openstack_blockstorage_volume_v3.volume-cirros.id}"
}

### FLOATING IP
data "openstack_networking_network_v2" "ext_network" {
  name = "rede-externa"
}
resource "openstack_networking_floatingip_v2" "floating_ip1" {
  pool = "rede-externa"
}
resource "openstack_compute_floatingip_associate_v2" "floating" {
  floating_ip = "${openstack_networking_floatingip_v2.floating_ip1.address}"
  instance_id = "${openstack_compute_instance_v2.cirros.id}"
}
### ----------------------------------------------------------------------- ###