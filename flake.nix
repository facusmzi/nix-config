{
  description = "Mi configuración NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ewm = {
      url = "https://codeberg.org/ezemtsov/ewm/archive/master.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    laminix = {
      url = "github:jackboykin/laminix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    plasma-manager,
    dms,
    sops-nix,
    ewm,
    laminix,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };

    overlay-packages = import ./overlays/default.nix;

    mkHomeManager = extraSharedModules: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.facusmzi = import ./home/facusmzi;
      home-manager.backupFileExtension = "backup";
      home-manager.sharedModules =
        [
          plasma-manager.homeModules.plasma-manager
        ]
        ++ extraSharedModules;
    };
  in {
    nixosConfigurations = {
      nixi = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ({...}: {
            nixpkgs.overlays = [overlay-unstable overlay-packages];
            nixpkgs.config.allowUnfree = true;
          })
          sops-nix.nixosModules.sops
          inputs.laminix.nixosModules.default
          ./hosts/nixi/configuration.nix
          ./hosts/nixi/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          (mkHomeManager [inputs.dms.homeModules.dank-material-shell])
        ];
      };

      nily = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ({...}: {
            nixpkgs.overlays = [overlay-unstable overlay-packages];
            nixpkgs.config.allowUnfree = true;
          })
          sops-nix.nixosModules.sops
          inputs.laminix.nixosModules.default
          ./hosts/nily/configuration.nix
          ./hosts/nily/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          (mkHomeManager [])
        ];
      };
    };

    templates = import ./templates/default.nix;
  };
}
