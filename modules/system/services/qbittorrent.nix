# modules/system/services/qbittorrent.nix
{...}: {
  services.qbittorrent = {
    enable = true;
    openFirewall = true; # abre webuiPort y torrentingPort
    webuiPort = 8080;
    torrentingPort = 6881;
    user = "facusmzi";
    group = "users";

    serverConfig = {
      Preferences = {
        Downloads = {
          # Carpeta donde van a caer las descargas
          SavePath = "/home/facusmzi/Vídeos";
        };
        WebUI = {
          # Deshabilita la verificación del host para acceso local
          LocalHostAuth = false;
        };
      };
    };
  };
}
