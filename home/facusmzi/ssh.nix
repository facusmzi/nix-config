{...}: {
  programs.ssh.settings = {
    "github.com" = {
      HostName = "github.com";
      User = "git";
      IdentityFile = "~/.ssh/key1";
      IdentitiesOnly = true;
    };

    "github.com-work" = {
      HostName = "github.com";
      User = "git";
      IdentityFile = "~/.ssh/key2";
      IdentitiesOnly = true;
    };

    "nixi" = {
      HostName = "192.168.100.2";
      User = "facusmzi";
      IdentityFile = "~/.ssh/nily_to_nixi";
      IdentitiesOnly = true;
    };
  };
}
