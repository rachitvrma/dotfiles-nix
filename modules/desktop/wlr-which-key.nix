{
  flake.homeModules.wlr-which-key = { config, ... }: {
    programs.wlr-which-key =
      let
        colors = config.lib.stylix.colors.withHashtag;
        run = cmd: "systemd-run --user ${cmd}";
        commonSettings = {
          font = "monospace 12";
          background = colors.base00 + "d0";
          color = colors.base05;
          border = colors.base0E;
          separator = " ➜ ";
          border_width = 2;
          corner_r = 10;
          padding = 15;
          rows_per_column = 5;
          column_padding = 25;
          anchor = "bottom-right";
          margin_right = 0;
          margin_bottom = 0;
          margin_left = 0;
          margin_top = 0;
        };
      in
      {
        enable = true;
        settings = commonSettings // {
          menu =
            let
              session-cmd = cmd: "noctalia msg session ${cmd}";
            in
            [
              {
                key = "l";
                desc = "Lock";
                cmd = session-cmd "lock";
              }
              {
                key = "p";
                desc = "Power-Off";
                cmd = session-cmd "shutdown";
              }
              {
                key = "r";
                desc = "Reboot";
                cmd = session-cmd "reboot";
              }
              {
                key = "s";
                desc = "Sleep";
                cmd = session-cmd "lock-and-suspend";
              }
            ];
        };

        extraMenus = {
          browsers = commonSettings // {
            menu = [
              {
                key = "f";
                desc = "Firefox";
                cmd = run "firefox";
              }
              {
                key = "q";
                desc = "Qutebrowser";
                cmd = run "qutebrowser";
              }
            ];
          };
        };
      };
  };
}
