# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../audio.nix
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
          ips = [
            ####
            ####
          ];
          peers = [{
            allowedIPs = [
              ####
              ####
              ####
              ####
              ####
              ####
              ####
              ####
            ];
            #endpoint = ####;
            #publicKey = ####;
            persistentKeepalive = 15;
          }];
          #privateKey = ####;
        };
      };
    };
  };

  services.dnsmasq = {
    enable = true;
    servers = [
      ####
      ####
      "9.9.9.9"
      "149.112.112.112"
    ];
  };

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

  users.users.thibaut = {
    isNormalUser = true;
    description = "Thibaut";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  services.pcscd.enable = true;

  zramSwap.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
