{ config, pkgs, ... }:

# sops-nix usa la clave host SSH (/etc/ssh/ssh_host_ed25519_key)
# para desencriptar secretos al hacer rebuild.
#
# Workflow inicial (una sola vez por host):
#
#   1. Obtener la clave pública del host:
#      $ ssh-keyscan localhost | ssh-to-age
#
#   2. Agregarla a .sops.yaml con el host correspondiente
#
#   3. Crear/editar secretos:
#      $ sops secrets/common.yaml

{
  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age   # convierte clave SSH host → clave age
  ];

  sops = {
    # Clave que usa este host para desencriptar
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # Directorio donde viven los secretos encriptados
    defaultSopsFile = ../../secrets/common.yaml;
    defaultSopsFormat = "yaml";
  };
}
