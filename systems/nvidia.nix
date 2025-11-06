{ config, ... }:

{
  hardware.graphics = {
    enable = true;

    #extraPackages = with pkgs; [
    #  nvidia-vaapi-driver
    #];
  };

  environment.variables = {
    PROTON_HIDE_NVIDIA_GPU = 0;
    PROTON_ENABLE_NVAPI = 1;
    PROTON_ENABLE_NGX_UPDATER = 1;
    #VKD3D_CONFIG = "dxr11,dxr";
    #VKD3D_FEATURE_LEVEL = "12_2";
    DXVK_FRAME_RATE = 240;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
