vpc_cidr          = "172.20.0.0/16"
sim_internet_cidr = "172.20.70.0/24"
dmz_cidr          = "172.20.60.0/24"
on_prem_cidr      = "172.20.50.0/24"
region            = "us-east-1"

# VM Configurations
main_instance_type = "t3.small"
main_vol_size      = 8

## VM Key Pairs
server_kp = "./cloudlab_kp.pub"
kali_kp   = "./cloudlab_kp.pub"
wazuh_kp  = "./cloudlab_kp.pub"

