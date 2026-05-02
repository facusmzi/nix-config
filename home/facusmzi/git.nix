{ config, ... }:

{
  sops.age.sshKeyPaths  = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile  = ../../secrets/common.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.secrets."git/user1_name"  = { };
  sops.secrets."git/user1_email" = { };
  sops.secrets."git/user2_name"  = { };
  sops.secrets."git/user2_email" = { };

  programs.bash.initExtra = ''
    export GIT_AUTHOR_NAME=$(cat ${config.sops.secrets."git/user1_name".path})
    export GIT_AUTHOR_EMAIL=$(cat ${config.sops.secrets."git/user1_email".path})
    export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
    export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
  '';

  programs.git.includes = [
    {
      condition = "gitdir:~/work/";
      contents.core.sshCommand = "ssh -i ~/.ssh/key2 -F /dev/null";
    }
  ];
}
