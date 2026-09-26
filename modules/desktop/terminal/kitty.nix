{
  flake.homeModules.kitty-desktopIntegration =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.kitty.enableDesktopIntegration;
    in
    {
      options.programs.kitty.enableDesktopIntegration = lib.mkEnableOption "enable kitty's portal implementation";
      config = lib.mkIf cfg {
        xdg.dataFile."xdg-desktop-portal/portals/kitty.portal".text = ''
          [portal]
          DBusName=org.freedesktop.impl.portal.desktop.kitty
          Interfaces=org.freedesktop.impl.portal.Settings;org.freedesktop.impl.portal.FileChooser;
        '';

        xdg.dataFile."dbus-1/services/org.freedesktop.impl.portal.desktop.kitty.service".text = ''
          [D-BUS Service]
          Name=org.freedesktop.impl.portal.desktop.kitty
          Exec=${pkgs.kitty}/bin/kitten desktop-ui run-server
        '';

        xdg.portal.config = {
          umbriel = {
            "org.freedesktop.impl.portal.Settings" = "kitty;*";
            "org.freedesktop.impl.portal.FileChooser" = "kitty;*";
          };
        };
      };
    };
  flake.homeModules.kitty = {
    programs.kitty = {
      enable = true;
      enableDesktopIntegration = true;
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
