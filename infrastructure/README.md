- Build the Images in `images` first
- Apply terraform in infrastructure/libvirt
- Apply terraform in infrastructure/docker
- Use avahi to setup local domains for testing:
  avahi-publish -a -R nextcloud.local <DOCKER-IP> &