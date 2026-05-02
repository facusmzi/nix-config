{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.openssh ];

  services.openssh = {
    enable = true;
    openFirewall = false;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };

    # Deshabilitar GSSAPIAuthentication
    extraConfig = "GSSAPIAuthentication no";

    # Filtrar moduli débiles (< 3071 bits) — mejora seguridad de DH
    moduliFile = pkgs.runCommand "filterModuliFile" {} ''
      awk '$5 >= 3071' "${config.programs.ssh.package}/etc/ssh/moduli" >"$out"
    '';

    # Solo clave ed25519 con más entropy (default es 16 rounds)
    hostKeys = [
      {
        comment = "${config.networking.hostName}.local";
        path = "/etc/ssh/ssh_host_ed25519_key";
        rounds = 100;
        type = "ed25519";
      }
    ];
  };
}
