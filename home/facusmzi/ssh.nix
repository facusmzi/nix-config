{ ... }:

{
  programs.ssh.matchBlocks."github.com" = {
    hostname = "github.com";
    user = "git";
    identityFile = "~/.ssh/key1";
    identitiesOnly = true;
  };
}
