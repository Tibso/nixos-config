{ pkgs, ...}:

{
  home.packages = [ pkgs.mangohud ];

  home.file.".config/MangoHud/MangoHud.conf".text = ''
    # time
    # time_format=%H:%M

    fps
    frametime=0

    gpu_stats
    gpu_temp
    gpu_power
    # gpu_fan
    vram

    cpu_stats
    cpu_temp
    # don't work cpu_power

    # disable frametime graph
    frame_timing=0

    # don't work font-scale=0.5
    # don't work font-size=12
    # don't work position=top-right
    # hud_compact
    horizontal
    background_alpha=0
    hud_no_margin
    offset_x=0
    offset_y=0
  '';
}
