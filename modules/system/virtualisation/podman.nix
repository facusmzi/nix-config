{ pkgs, ... }:

{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;   # alias docker → podman, para compatibilidad
      defaultNetwork.settings.dns_enabled = true; # DNS entre contenedores con podman-compose
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose   # drop-in de docker-compose
    skopeo           # inspeccionar/copiar imágenes de registries
    dive             # explorar capas de imágenes
  ];

  users.users.facusmzi.extraGroups = [ "podman" ];
}
