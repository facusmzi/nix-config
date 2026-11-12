{...}: {
  programs.ssh.settings = {
    "github.com" = {
      HostName = "github.com";
      User = "git";
      IdentityFile = "~/.ssh/key1";
      IdentitiesOnly = true;
    };
  };
}
