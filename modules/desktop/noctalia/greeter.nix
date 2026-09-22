{
  flake.nixosModules.noctalia_greeter = { config, ... }: {
    services.displayManager.noctalia-greeter = {
      enable = true;
      passwordlessSyncUsers = [ "krish" ];
      cursorTheme = {
        name = config.stylix.cursor.name;
        package = config.stylix.cursor.package;
      };
      settings = {
        cursor = {
          size = config.stylix.cursor.size;
          theme = config.stylix.cursor.name;
        };
        keyboard = {
          inherit (config.services.xserver.xkb)
            layout
            variant
            options
            ;
          numlock = true;
        };
        user = {
          default = "krish";
        };
        appearance = {
          scheme = "Synced";
          password_style = "random";
          hide_logo = true;
          font_family = "monospace";
        };
        auth = {
          allow_empty_password = false;
          request_timeout = 60;
        };
      };
    };
  };
}
