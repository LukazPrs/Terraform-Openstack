### IMPORTANDO SECGROUP(ADICIONAR BLOCO DO SECGROUP A SER IMPORTADO...):

# resource "openstack_compute_secgroup_v2" "secgroup" {
#   name        = "secgroup"
#   description = "adicionar valores do secgroup existente..."
# }

# $ terraform import openstack_compute_secgroup_v2.my_secgroup ID

## ----------------------------------------------------------------------- ##

### IMPORTANDO INSTANCIA JÁ EXISTENTE(ADICIONAR BLOCO DA INSTANCIA ANTES DO IMPORT...)

# resource "openstack_compute_instance_v2" "ubuntu" {
#   name            = "ubuntu-20"
#   image_id        = "${openstack_images_image_v2.ubuntu.id}"
#   flavor_id       = "6"
#   key_pair        = "minha_chave"
#   security_groups = ["default"]

#   block_device {
#     uuid                  = "${openstack_images_image_v2.ubuntu.id}"
#     source_type           = "image"
#     destination_type      = "volume"
#     boot_index            = 0
#     delete_on_termination = true
#     volume_size           = 8    
#   }

#   network {
#     name = "rede100"
#   }
# }

## $ terraform import openstack_compute_instance_v2.instance_2 <instance_id> import openstack_blockstorage_volume_v2.volume_1 <volume_id>
## $ terraform import openstack_compute_volume_attach_v2.va_1 <instance_id>/<volume_id>


### IMPORTANDO REDE E ROUTER

### terraform import openstack_networking_network_v2.externa ID
# resource "openstack_networking_network_v2" "externa" {
#   name           = "externa"
#   admin_state_up = "true"
# }

# $ terraform import openstack_networking_network_v2.network_1 ID

# resource "openstack_networking_router_v2" "router" {
#   name                = "router"
#   admin_state_up      = true
# #  external_network_id = "f67f0d72-0ddf-11e4-9d95-e1f29f417e2f"
# }

# $ terraform import openstack_networking_router_v2.router_1 ID