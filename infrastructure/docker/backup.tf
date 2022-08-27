data "sops_file" "borg" {
  source_file = "../../keys/borg.yml"
}

locals {
  backup_filename = "/home/${var.hypervisor_user}/backup_script.sh"
}

resource "ssh_resource" "backup" {
  host         = var.hypervisor_host
  user         = var.hypervisor_user
  agent = true

  when         = "create"

  file {
    destination = local.backup_filename
    permissions = "0700"

    content = templatefile("backup_script.tpl.sh", {
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

  file {
    permissions = "0700"
    destination = "backup_wrapper.sh"
    content     = templatefile("files/backup_wrapper.sh", {
      healthcheck = healthchecksio_check.backup.ping_url
      backup_script = local.backup_filename
    })
  }

  commands = [
    "echo \"5 2 * * * root $(realpath backup_wrapper.sh) > /dev/null\" | sudo tee /etc/cron.d/backup.cron"
  ]
}