vpc_cidr          = "172.20.0.0/16"
sim_internet_cidr = "172.20.70.0/24"
dmz_cidr          = "172.20.60.0/24"
on_prem_cidr      = "172.20.50.0/24"
region            = "us-east-1"

allow_public_ip = false

# VM Configurations
main_instance_type = "t3.small"
main_vol_size      = 10

## VM Key Pairs
### By default the 3 VMs use the same key pair located under usr/home/.ssh; 
### Each VM can have it's own key pair by creating a key pair for each and modifying the path here
server_kp = "./cloudlab_kp.pub"
parrot_kp   = "./cloudlab_kp.pub"
wazuh_kp  = "./cloudlab_kp.pub"

