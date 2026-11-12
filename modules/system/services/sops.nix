{ config, pkgs, ... }:

# sops-nix (a nivel sistema) usa la clave host SSH
# (/etc/ssh/ssh_host_ed25519_key) para desencriptar los secretos durante
# `nixos-rebuild`. Corre como root, así que puede leer la clave host; los
# secretos quedan en /run/secrets/ con el dueño que se indique.
#
# Destinatarios (ver .sops.yaml):
#   - admin: clave age personal, guardada FUERA de las máquinas (respaldo)
#   - nily / nixi: claves host convertidas a age
#
# Agregar un host nuevo:
#   $ ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub   # → .sops.yaml
#   $ sops updatekeys secrets/common.yaml                # desde una máquina con acceso
#
# Editar secretos (sin copiar la clave host a ningún lado):
#   $ sudo env SOPS_AGE_SSH_PRIVATE_KEY_FILE=/etc/ssh/ssh_host_ed25519_key \
#       sops secrets/common.yaml
#   o, con la clave admin en ~/.config/sops/age/keys.txt:
#   $ sops secrets/common.yaml

let
  user = "facusmzi";
in
{
  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age   # convierte clave SSH host → clave age
  ];

  sops = {
    # Clave que usa este host para desencriptar
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    defaultSopsFile = ../../../secrets/common.yaml;
    defaultSopsFormat = "yaml";

    # Identidades de git
    secrets."git/user1_name".owner = user;
    secrets."git/user1_email".owner = user;
    secrets."git/user2_name".owner = user;
    secrets."git/user2_email".owner = user;

    # Archivos de identidad listos para `git include`.
    # Quedan en /run/secrets/rendered/<nombre>, legibles solo por el usuario.
    templates."git-identity" = {
      owner = user;
      content = ''
        [user]
          name = ${config.sops.placeholder."git/user1_name"}
          email = ${config.sops.placeholder."git/user1_email"}
      '';
    };

    templates."git-identity-work" = {
      owner = user;
      content = ''
        [user]
          name = ${config.sops.placeholder."git/user2_name"}
          email = ${config.sops.placeholder."git/user2_email"}
      '';
    };
  };
}
