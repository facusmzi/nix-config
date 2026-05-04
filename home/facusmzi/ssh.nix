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
}
