#!/bin/bash

export SOPS_AGE_KEY_FILE=/home/felix/Nextcloud/terraform_keys/sops_age_key.txt

# Host SSH Keys
export PKR_VAR_dsa_private=$(sops --decrypt backup/keys/ssh_host_dsa_key.enc.key)
export PKR_VAR_ecdsa_private=$(sops --decrypt backup/keys/ssh_host_ecdsa_key.enc.key)
export PKR_VAR_ed25519_private=$(sops --decrypt backup/keys/ssh_host_ed25519_key.enc.key)
export PKR_VAR_rsa_private=$(sops --decrypt backup/keys/ssh_host_rsa_key.enc.key)

# Admin user
export PKR_VAR_username=$(sops --decrypt --extract '["username"]' backup/keys/user.enc.yml)
export PKR_VAR_password=$(sops --decrypt --extract '["password"]' backup/keys/user.enc.yml)

#echo 'variables' | packer console backup/variables.pkr.hcl
packer build backup
