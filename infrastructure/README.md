- Build the Images in `images` first
- Apply terraform in infrastructure/libvirt
- Apply terraform in infrastructure/docker
- Use avahi to setup local domains for testing:
  avahi-publish -a -R nextcloud.local <DOCKER-IP> &


# Routed Network

Damit die Fritzbox nicht für VMs IP Adressen vergeben muss, verwende Routing. Dazu in der Fritzbox unter Netzwerk -> Netzwerkeinstellungen -> Statische Routingtabelle das Subnetz routen.

Dabei beachten, dass nicht eventuell schon auf dem Entwicklerrechner eine Route für das Netzwerk existiert (z.B. von Docker oder libvirt)