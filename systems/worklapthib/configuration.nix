# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../audio.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "googleearth-pro-7.3.6.10201"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    hostName = "worklapthib";

    networkmanager.enable = true;
    networkmanager.dns = "none";

    wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          ips = lib.filter (s: s != "") (lib.splitString "\n" (builtins.readFile "/nix/persist/secrets/wireguard/wg0-ips"));
          peers = [{
            allowedIPs = lib.filter (s: s != "") (lib.splitString "\n" (builtins.readFile "/nix/persist/secrets/wireguard/wg0-peer-allowed-ips"));
            endpoint = lib.removeSuffix "\n" (builtins.readFile "/nix/persist/secrets/wireguard/wg0-peer-endpoint");
            publicKey = lib.removeSuffix "\n" (builtins.readFile "/nix/persist/secrets/wireguard/wg0-peer-public-key");
            persistentKeepalive = 15;
          }];
          privateKeyFile = "/nix/persist/secrets/wireguard/wg0-private-key";
        };
      };
    };
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      server = lib.filter (s: s != "") (lib.splitString "\n" (builtins.readFile "/nix/persist/secrets/dnsmasq/servers"))
        ++ [ "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ]; # quad9
      listen-address = [ "127.0.0.1" "::1" "172.100.0.1" ];
    };
  };

  hardware.bluetooth.powerOnBoot = false;

  time.timeZone = "Europe/Luxembourg";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "be";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "be-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.gnupg.agent.enable = true;

  users.users.thibaut = {
    isNormalUser = true;
    description = "Thibaut";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      default-address-pools = [{ base = "172.100.0.0/16"; size = 24; }];
      dns = [ "172.100.0.1" ];
      insecure-registries = [ "localhost:5000" "127.0.0.1:5000" ];
    };
  };

  services.pcscd.enable = true;

  # zram on 16GB of RAM is not sufficient
  #zramSwap.enable = true;
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16*1024;
  }];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
