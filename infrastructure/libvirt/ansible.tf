resource "local_file" "ansible_inventory" {
  filename = "inventory.yml"
  content  = yamlencode({
    all : {
      hosts : {
        for node in module.kubernetes[*] : node.hostname => {
          ansible_host : node.addresses
          ansible_user : "ansible"
        }
      }
    },

    kube_control_plane: {
      hosts: {
        for node in module.kubernetes[*] : node.hostname => {
          ansible_host : node.addresses
          ansible_user : "ansible"
        }
      }
    }

    etcd: {
      hosts: {
      for node in module.kubernetes[*] : node.hostname => {
        ansible_host : node.addresses
        ansible_user : "ansible"
      }
      }
    }

    kube_node: {
      hosts: {
      for node in module.kubernetes[*] : node.hostname => {
        ansible_host : node.addresses
        ansible_user : "ansible"
      }
      }
    }

    kube_node: {
      hosts: {
      for node in module.kubernetes[*] : node.hostname => {
        ansible_host : node.addresses
        ansible_user : "ansible"
      }
      }
    }

    calico_rr: {}

    k8s_cluster: {
      children: {
        kube_control_plane: {}
        kube_node: {}
        calico_rr: {}
      }
    }
  })
}