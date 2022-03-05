Due to https://github.com/hashicorp/terraform/issues/2430 VMs have to be created 
by running terraform apply in vm directory before the containers can be created

By using remote state it might be possible to pass the flatcar ip to the second call
