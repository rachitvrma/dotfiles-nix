{
  flake.nixosModules.umbriel = { pkgs, ... }: {
    programs.umbriel.enable = true;
    programs.gnupg.agent.pinentryPackage = pkgs.pinentry-egui;
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
      # Pinentry-Egui is the package that works best with window managers
      services.gpg-agent.pinentry = {
        package = pkgs.pinentry-egui;
      };
      wayland.windowManager.umbriel = {
        enable = true;
        settings =
          let
            colors = config.lib.stylix.colors.withHashtag;
          in
          lib.mkMerge [
            (lib.importTOML ./umbriel.toml)
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
              # colors = {
              #   background = colors.base00;
              #   text_primary = colors.base05;
              #   text_muted = colors.base04;
              #   accent_primary = colors.base0E;
              #   accent_secondary = colors.base0A;
              #   warning = colors.base09;
              #   error = colors.base08;
              #   insert_hint = colors.base0D;
              #   backdrop = colors.base00;
              #   shadow = colors.base01;

              #   border = {
              #     focused = colors.base0E;
              #     unfocused = colors.base02;
              #     scratchpad_focused = colors.base0A;
              #     scratchpad_unfocused = colors.base03;
              #     outer = colors.base00;
              #   };
              # };
            }
          ];
      };
    };
}
