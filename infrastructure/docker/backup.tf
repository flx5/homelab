data "sops_file" "borg" {
  source_file = "../../keys/borg.yml"
}

resource "ssh_resource" "backup" {
  host         = var.hypervisor_host
  user         = var.hypervisor_user

  when         = "create"

  file {
    destination = "backup_script.sh"
    permissions = "0700"

    content = templatefile("script_tpl.sh", {
      borg_repos = [
        {
          repository = data.sops_file.borg.data["onsite.repository"],
          passphrase = data.sops_file.borg.data["onsite.passphrase"]
        },
        {
          repository = data.sops_file.borg.data["offsite.repository"],
          passphrase = data.sops_file.borg.data["offsite.passphrase"]
        }
      ]

      dump_folder = local.dump_folder

      hosts = {
        web = {
          vm_name  = "docker_web"
          username = var.docker_web_user
          address  = var.docker_web_host
          scripts  = module.web.backup

          # TODO Do not track these manually. Take the values from the libvirt terraform scripts instead.
          lvm = [
            { vg = "pve-ssd", lv = "nextcloud", snapshot_size = "10G" }
          ]
        }

        media = {
          vm_name  = "docker_media"
          username = var.docker_media_user
          address  = var.docker_media_host
          scripts  = module.media.backup,

          lvm = [
            { vg = "disk1", lv = "media", snapshot_size = "10G" },
            { vg = "disk2", lv = "media", snapshot_size = "10G" },
            { vg = "disk3", lv = "media", snapshot_size = "10G" }
          ]
        }
        internal = {
          vm_name  = "docker_internal"
          username = var.docker_internal_user
          address  = var.docker_internal_host
          scripts  = module.internal.backup,

          lvm = [
            { vg = "disk1", lv = "stash", snapshot_size = "10G" },
            { vg = "disk2", lv = "stash", snapshot_size = "10G" },
            { vg = "disk3", lv = "stash", snapshot_size = "10G" }
          ]
        }
      }
    })
  }
}