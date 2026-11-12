{osConfig, ...}: let
  # Generados por sops-nix a nivel sistema (modules/system/services/sops.nix)
  identity = osConfig.sops.templates."git-identity".path;
  identityWork = osConfig.sops.templates."git-identity-work".path;
in {
  programs.git.includes = [
    # Identidad principal (cuenta personal)
    {path = identity;}

    # Identidad y clave SSH de la cuenta de trabajo para todo lo que esté en ~/work/.
    # Se clona con la URL normal (git@github.com:...), no hace falta alias.
    {
      condition = "gitdir:~/work/";
      path = identityWork;
    }
    {
      condition = "gitdir:~/work/";
      contents.core.sshCommand = "ssh -i ~/.ssh/key2 -F /dev/null -o IdentitiesOnly=yes";
    }
  ];
}
