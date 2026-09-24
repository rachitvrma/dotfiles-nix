{ inputs, ... }:
let
  commonStylix = pkgs: config: lib: {
    stylix = {
      enable = true;
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
      image = inputs.wallpapers + "/wallhaven-0w9zk6.jpg";

      /*
            override = {
              base00 = "141617";
            };
      */

      polarity = "dark";

      cursor = {
        name = "phinger-cursors-light";
        package = pkgs.phinger-cursors;
        size = 32;
      };

      icons =
        let
          /*
            gruvbox = {
              dark = "Gruvbox-Plus-Dark";
              light = config.stylix.icons.dark;
              package = pkgs.gruvbox-plus-icons.override {
                folder-color = "purple";
              };
            };
          */
          papirus = {
            dark = "Papirus-Dark";
            light = "Papirus-Light";
            package = pkgs.papirus-icon-theme.override { color = "blue"; };
          };
        in
        {
          enable = true;
        }
        // papirus;

      fonts = {
        serif = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        sansSerif = config.stylix.fonts.serif;
        monospace = config.stylix.fonts.serif;
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
      /*
            opacity = rec {
              desktop = 0.92;
              terminal = desktop;
              popups = desktop;
              applications = desktop;
            };
      */
    };
  };
in
{
  flake.nixosModules.stylix =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports = [ inputs.stylix.nixosModules.stylix ];
      gtk.iconCache.enable = true;
      stylix.overlays.enable = true; # This is a NixOS only option

      qt = {
        enable = true;
      };

      # Required for configuring extra fonts, like symbols-only-nerd font
      # Enabling this in nixosModules, automatically enables in home-manager.
      fonts = {
        # enableDefaultPackages = false;

        # Not using lib.mkAfter can override stylix's default
        packages = lib.mkAfter (
          with pkgs;
          [
            nerd-fonts.symbols-only
          ]
        );
        fontconfig = {
          enable = true;
        };
      };
    }
    // (commonStylix pkgs config lib);

  flake.homeModules.stylix =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      fonts.fontconfig.enable = true;
      # A lot of applications don't work without this, so let this be here
      home.packages = with pkgs; [ nerd-fonts.symbols-only ];

      qt = {
        enable = true;
        kvantum.enable = true;
      };
    }
    // (commonStylix pkgs config lib);
}
