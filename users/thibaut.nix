{ pkgs, ... }:

{
  imports = [
    ../pkgs/nixvim/nixvim.nix
    ../pkgs/tmux.nix
  ];

  home.username = "thibaut";
  home.homeDirectory = "/home/thibaut";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05";

  services.gpg-agent.enable = true;

  home.packages = with pkgs; [
    # should check how many of these should only be present in a nix-shell
    gnumake
    openssl
    usbutils
    pciutils
    googleearth-pro
    gnupg
    pass
    (pkgs.burpsuite.override {
      proEdition = true;
    })
    neofetch
    aircrack-ng
    whois
    xclip
    rustup
    thunderbird-latest
    blender
    pulseeffects-legacy
    cool-retro-term
    nerd-fonts.jetbrains-mono
    tree
    pigz
    fzf
    vlc
    vlc-bittorrent
    qbittorrent
    gimp
    libreoffice
    libstrangle
    reaper
    git
    davinci-resolve
    python312
    unzip
    jdk
    wirelesstools
    yt-dlp
    speedtest-cli
    dig
    ripgrep
    wget
    gcc
    nmap
    tcpdump
    ffmpeg
    firefox
    gnomeExtensions.astra-monitor
    gnomeExtensions.tactile
    gnome-tweaks
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tibso/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
  
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -lh";
    };
    bashrcExtra = ''
      export PS1="\n\[\e[1;32m\]\u\[\e[m\] \[\e[1;35m\]\w\[\e[m\] \[\e[1m\]\$\[\e[m\] ";
      export HORIZON_PASSWORD_XCLIP=true
      export HORIZON_PASSWORD_EXPORT=~/.passm/current-horizon.csv
    '';
    initExtra = ''
      if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        if tmux ls &> /dev/null; then
          exec tmux a
        else
          exec tmux
        fi
      fi
    '';
  };

  programs.home-manager.enable = true;
}
