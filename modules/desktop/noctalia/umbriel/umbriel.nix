{
  flake.nixosModules.umbriel = { ... }: {
    programs = {
      umbriel.enable = true;
    };
  };
  flake.homeModules.umbriel =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      xdg = {
        portal = {
          extraPortals = with pkgs; [
            xdg-desktop-portal-umbriel
          ];
          configPackages = [ pkgs.umbriel ];
        };
      };

      wayland.windowManager.umbriel = {
        enable = true;
        settings =
          let
            colors = config.lib.stylix.colors.withHashtag;
            imported = map lib.importTOML (
              lib.fileset.toList (lib.fileset.fileFilter (file: file.hasExt "toml") ./config)
            );
          in
          lib.mkMerge (
            imported
            ++ [
              {
                input = {
                  cursor = {
                    theme = config.stylix.cursor.name;
                    size = config.stylix.cursor.size;
                  };
                  keyboard = {
                    layout = config.home.keyboard.layout;
                    options = lib.concatStringsSep "," config.home.keyboard.options;
                    variant = config.home.keyboard.variant;
                  };
                };
                colors = {
                  background = colors.base00;
                  text_primary = colors.base05;
                  text_muted = colors.base04;
                  accent_primary = colors.base0E;
                  accent_secondary = colors.base0A;
                  warning = colors.base09;
                  error = colors.base08;
                  insert_hint = colors.base0D;
                  backdrop = colors.base00;
                  shadow = colors.base01;

                  border = {
                    focused = colors.base0E;
                    unfocused = colors.base02;
                    outer = colors.base00;
                  };
                };
              }
            ]
          );
      };
    };
}
