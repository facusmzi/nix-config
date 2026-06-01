{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/system/desktop
    ../../modules/system/services
    ../../modules/system/packages
    ../../modules/system/editors

    ../../emacs
    ../../modules/system/services/samba.nix
  ];

  # Configuración básica del host
  networking.hostName = "nixi";

  # Scrubbing automático de Btrfs
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"];
  };

  boot.tmp.cleanOnBoot = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };

  boot.loader = {
    timeout = 30;

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot"; # Asegúrate que coincida con tu partición EFI
    };
    grub = {
      enable = true;
      device = "nodev"; # Para UEFI
      efiSupport = true;
      #useOSProber = true; # Detecta otros sistemas operativos

      # Entradas manuales para dual/triple boot
      extraEntries = ''
        menuentry "Windows 10" {
          insmod part_gpt
          insmod fat
          insmod ntfs
          insmod chain
          set root='hd0,gpt1'
          search --no-floppy --fs-uuid --set=root 8B20-9D40
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }

        menuentry "Debian" {
          insmod part_gpt
          insmod fat
          insmod chain
          set root='hd0,gpt1'
          search --no-floppy --fs-uuid --set=root 8B20-9D40
          chainloader /EFI/debian/shimx64.efi
        }
      '';
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Argentina/Buenos_Aires";
  i18n.defaultLocale = "es_AR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };

  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

  console.keyMap = "es";

  #services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # firewall?
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [22];

  # Usuario
  users.users.facusmzi = {
    isNormalUser = true;
    description = "facusmzi";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIByBShyZcM+mCQVqp+Jylh4oFtmLcO4StISJF8NEIVHX nily→nixi"
    ];
  };

  # Paquetes básicos del sistema
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop

    libreoffice-fresh
    ntfs3g
    p7zip
    bitwarden-desktop
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org" # Community
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Habilitar flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.05";
}
