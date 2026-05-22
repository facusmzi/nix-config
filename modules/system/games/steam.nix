{ pkgs, ... }:

{



 # Habilitar Steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;  # Para Steam Remote Play
      dedicatedServer.openFirewall = true;  # Para servidores dedicados
      gamescopeSession.enable = true;  # Mejor compatibilidad con Wayland
    };

    # Habilitar soporte de 32-bit para juegos antiguos
    hardware.graphics = {
      enable = true;
      enable32Bit = true;  # Necesario para juegos de 32-bit
    };

    # Paquetes adicionales relacionados con gaming
    environment.systemPackages = with pkgs; [
      mangohud  # Overlay para FPS y estadísticas
      gamescope  # Compositor para gaming
    ];

    # Optimizaciones para gaming (opcional)
    boot.kernel.sysctl = {
      "vm.max_map_count" = 2147483642;  # Para algunos juegos que necesitan muchos memory maps
    };



}
