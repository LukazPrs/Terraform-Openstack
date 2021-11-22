# Configure the OpenStack Provider
provider "openstack" {
  user_name   = "${var.provider_user}"
  tenant_name = "${var.provider_tenant}"
  password    = "${var.provider_pass}"
  auth_url    = "http://controller:5000/v3"
  region      = "RegionOne"
}