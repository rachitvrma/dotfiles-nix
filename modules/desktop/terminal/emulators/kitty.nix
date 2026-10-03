# Remember to change the default xdg-terminal-exec
{
  flake.homeModules.kitty = { config, ... }: {
    programs.kitty = {
      enable = false;
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
        cursor_trail_color = config.lib.stylix.colors.withHashtag.base0E;
        cursor_trail_start_threshold = 2;

        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";

        allow_remote_control = true;

        custom_shaders = "cursor-trail-lightning";

        notify_on_cmd_finish = "unfocused";

        window_padding_width = 20;
      };
    };
  };
}
