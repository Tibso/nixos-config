{
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    mouse = true;
    aggressiveResize = true;
    clock24 = true;
    escapeTime = 10;
    terminal = "screen-256color";
    extraConfig = ''
      # reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "TMUX configuration reloaded!"

      # bind windows to 1234567890 on azerty
      bind -n M-& select-window -t 1
      bind -n M-é select-window -t 2
      bind -n M-\" select-window -t 3
      bind -n M-\' select-window -t 4
      bind -n M-\( select-window -t 5
      bind -n M-§ select-window -t 6
      bind -n M-è select-window -t 7
      bind -n M-! select-window -t 8
      bind -n M-ç select-window -t 9
      bind -n M-à select-window -t 10

      # use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # current path to new window
      bind c new-window -c "#{pane_current_path}"

      # change splitting
      bind h split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # enable vi mode keys
      set-window-option -g mode-keys vi

      # rebind kill window and remove confirmations
      bind-key x kill-pane
      bind-key g kill-window

      # start panel and window numbering at 1
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # allow focus events to get through to applications running in tmux
      set -g focus-events on

      # change notifications
      set -g activity-action none
      set -g visual-activity on
      set -g visual-bell off
      setw -g monitor-activity on
      set -g bell-action none

      # True Color
      set-option -a terminal-features 'xterm-256color:RGB'

      # status-bar cosmetics
      set -g status-position 'top'
      set -g status-style 'bold fg=white'
      set -g status-justify left

      set -g status-left ""
      set -g status-left-style 'fg=cyan'

      set -g window-status-current-format '#I:#W'
      set -g window-status-current-style 'fg=black bg=brown'
      set -g window-status-format '#I:#W'
      set -g window-status-style 'fg=brown'
      set -g window-status-activity-style 'fg=black bg=white'

      set -g status-right-style 'fg=black bg=yellow'
      set -g status-right ""
      #set -g status-right ' #(awk "{print \$1, \$2, \$3}" /proc/loadavg) '

      set -g message-style 'bold fg=white'
      setw -g window-status-bell-style 'bold bg=white fg=black'
    '';
   };
}
