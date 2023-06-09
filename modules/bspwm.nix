{ config, pkgs, ... }:

{
  imports = [ ./sxhkd.nix ];
  #options = {};

  config = {
    services.xserver = {
      windowManager.bspwm = {
        enable = true;
        configFile = "/etc/bspwmrc";
      };
    };
    environment.etc.bspwmrc = {
        mode = "0645";
        text = ''
          #!/usr/bin/env bash

          # spread desktops
          desktops=10
          count=$(xrandr -q | grep -c ' connected')
          i=1
          for m in $(xrandr -q | grep ' connected' | awk '{print $1}'); do
            sequence=$(seq -s ' ' $(((1+(i-1)*desktops/count))) $((i*desktops/count)))
            bspc monitor "$m" -d $(echo ''${sequence//10/0})
            i=$((i+1))
          done

          if [ -e "/etc/X11/Xresources" ]; then
            xrdb /etc/X11/Xresources
          fi
          if [ -e "$HOME/.Xresources" ]; then
            xrdb -merge "$HOME/.Xresources"
          fi
          # polybar
          #for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
          #  MONITOR=$m ${pkgs.polybar}/bin/polybar --reload default -c /etc/polybar.conf &
          #done

          # pointer
          xsetroot -cursor_name left_ptr
          # turn off blanking
          xset -dpms
          xset s off
          xset s noblank
          #numlockx on

          # border color
          bspc config focused_border_color  "#800080"
          bspc config normal_border_color   "#808080"
          bspc config border_width          "4"
          bspc config window_gap            0
          bspc config split_ratio           0.50
          bspc config borderless_monocle    true
          bspc config gapless_monocle       true
          bspc config single_monocle        false
          bspc config focus_follows_pointer false
          bspc config automatic_scheme      spiral

          bspc rule -a "-c" state=floating
          bspc rule -a Rofi state=floating
          bspc rule -a Ibus-ui-gtk3 state=floating
          bspc rule -a Pavucontrol state=floating
          bspc rule -a Nm-connection-editor state=floating
          bspc rule -a Calfjackhost state=floating
          bspc rule -a calfjackhost state=floating
          bspc rule -a .onboard-settings-wrapped state=floating
          bspc rule -a Zathura state=tiled

          # background image
          if [ -e "$HOME/.fehbg" ]; then
            source "$HOME/.fehbg"
          #else
          #  feh --bg-scale /etc/nixos/wallpaper.jpg
          fi
        '';
      };
  };
}


