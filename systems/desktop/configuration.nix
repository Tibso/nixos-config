{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../audio.nix
    ../nvidia.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "googleearth-pro-7.3.6.10201"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    hostName = "desktop-nixos";

    networkmanager.enable = true;
    networkmanager.dns = "none";

    firewall = {
      enable = true;
      allowedTCPPorts = [ 25565 ];
    };

    nameservers = [
      "9.9.9.9"
      "149.112.112.112"

      ];
  };

  time.timeZone = "Europe/Luxembourg";

  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "be";
    variant = "";
  };

  services.openssh = {
    enable = true;
  };

  console.keyMap = "be-latin1";

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tibso = {
    isNormalUser = true;
    description = "Thibaut";
    extraGroups = [ "networkmanager" "wheel" "docker"];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    #gamescopeSession.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  virtualisation.docker.enable = true;

  # Enable automatic login for the user.
  #services.displayManager.autoLogin.enable = true;
  #services.displayManager.autoLogin.user = "tibso";
  
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  #systemd.services."getty@tty1".enable = false;
  #systemd.services."autovt@tty1".enable = false;

  services.pcscd.enable = true;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    NIXOS_OZONE_WL = "1";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  zramSwap.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";}
