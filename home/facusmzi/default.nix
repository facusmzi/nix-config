{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home/ssh.nix
    ../../modules/home/git.nix

    ./git.nix
    ./ssh.nix
  ];

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    fastfetch
    #vencord-plugins-third
    vesktop
    kdePackages.kdenlive
    vlc
    vlc-bittorrent
    kdePackages.arianna
    tomato-c
    unzip
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      ".." = "cd ..";
    };
    initExtra = ''
      rebuild() {
        sudo nixos-rebuild switch --flake ~/nix-config#$(hostname)
      }
    '';
  };
}
