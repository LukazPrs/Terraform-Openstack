# Terraform Openstack


#### Criando recursos iniciais para utilização do openstack, como:

 - Flavors
 - Chave ssh
 - Redes, Sub-redes e Roteador
 - Imagens
 - Grupo de Segurança
 - Instancias, **etc.**

---
### HOW TO
Adicionando as variáveis de ambientes necessárias:

    # git clone git@github.com:LukazPrs/Terraform-Openstack.git
     
     (variaveis do provider)
    # TF_VAR_provider_user=
    # TF_VAR_provider_tenant=
    # TF_VAR_provider_pass=
    
    # terraform init
    # terraform plan
    # terraform apply

---
SCREENS

![enter image description here](https://uploaddeimagens.com.br/images/003/549/046/original/TERRAFORM-OPENSTACK-NETWORK.png?1637628615)

--
![enter image description here](https://uploaddeimagens.com.br/images/003/549/047/original/TERRAFORM-OPENSTACK-INSTANCE.png?1637628674)
