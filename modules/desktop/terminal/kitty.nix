{
  flake.homeModules.kitty = {
    programs.kitty = {
      enable = true;
      actionAliases = {
        launch_tab = "launch --cwd=current --type=tab";
        launch_window = "launch --cwd=current --type=os-window";
      };
      enableGitIntegration = true;
      settings = {
        enable_audio_bell = false;
        scrollback_lines = 10000;
        update_check_interval = 0;

        clipboard_control = "write-clipboard read-clipboard";

        cursor_trail = 1;
        cursor_trail_decay = "0.1 0.4";
        cursor_trail_start_threshold = 2;

        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";

        allow_remote_control = true;

        custom_shaders = "inside-the-matrix";

        notify_on_cmd_finish = "unfocused";

        window_padding_width = 20;
      };
    };
  };
}
