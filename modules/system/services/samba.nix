# modules/system/services/samba.nix
{pkgs, ...}: {
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "nily";
        "netbios name" = "nily";
        "security" = "user";
        "hosts allow" = "192.168.100. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };

      "videos" = {
        "path" = "/home/facusmzi/Videos";
        "browseable" = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
        "force user" = "facusmzi";
      };
    };
  };

  # Para que Windows/Android lo descubra automáticamente en la red
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
