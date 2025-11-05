{
  description = "Flakes nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nixvim = {
    #  url = "github:nix-community/nixvim";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {

      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./systems/desktop/configuration.nix
          ./systems/desktop/hardware-configuration.nix
          ./systems/nvidia.nix
          ./systems/audio.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tibso = ./users/tibso.nix;
          }
        ];
      };

      worklapthib = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./systems/worklapthib/configuration.nix
          ./systems/worklapthib/hardware-configuration.nix
          ./systems/audio.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.thibaut = ./users/thibaut.nix;
          }
        ];
      };
    };
  };
}
