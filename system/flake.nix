{
  description = "Flakes system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./desktop/configuration.nix
          ./desktop/hardware-configuration.nix
          ./audio.nix
          ./nvidia.nix
        ];
      };
    };
  };
}
