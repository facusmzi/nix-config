{ ... }:

{
  programs.ssh.matchBlocks."github.com" = {
    hostname = "github.com";
    user = "git";
    identityFile = "~/.ssh/key1";
    identitiesOnly = true;
  };

   programs.ssh.matchBlocks."github.com-work" = {
    hostname = "github.com";
    user = "git";
    identityFile = "~/.ssh/key2";
    identitiesOnly = true;
  };

  programs.ssh.matchBlocks."nixi" = {
    hostname = "192.168.100.2";  # ej: 192.168.1.105
    user = "facusmzi";
    identityFile = "~/.ssh/nily_to_nixi";
    identitiesOnly = true;
  };
}
