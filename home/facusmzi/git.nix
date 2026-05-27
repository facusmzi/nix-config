{
  config,
  lib,
  ...
}: {
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  sops.defaultSopsFile = ../../secrets/common.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.secrets."git/user1_name" = {};
  sops.secrets."git/user1_email" = {};
  sops.secrets."git/user2_name" = {};
  sops.secrets."git/user2_email" = {};

  # Genera los archivos de identidad desde sops al activar home-manager.
  # Así git los lee directamente sin depender de variables de entorno
  # ni de cómo se haya iniciado Emacs/Magit.
  home.activation.gitIdentity = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ -r "${config.sops.secrets."git/user1_name".path}" ]; then
          mkdir -p "$HOME/.config/git"
          cat > "$HOME/.config/git/identity" <<EOF
    [user]
      name = $(cat ${config.sops.secrets."git/user1_name".path})
      email = $(cat ${config.sops.secrets."git/user1_email".path})
    EOF
          cat > "$HOME/.config/git/identity-work" <<EOF
    [user]
      name = $(cat ${config.sops.secrets."git/user2_name".path})
      email = $(cat ${config.sops.secrets."git/user2_email".path})
    EOF
        fi
  '';

  programs.git.includes = [
    # Identidad principal (cuenta personal)
    {path = "~/.config/git/identity";}

    # Identidad secundaria para ~/work/
    {
      condition = "gitdir:~/work/";
      path = "~/.config/git/identity-work";
    }
    {
      condition = "gitdir:~/work/";
      contents.core.sshCommand = "ssh -i ~/.ssh/key2 -F /dev/null -o IdentitiesOnly=yes";
    }
  ];
}
