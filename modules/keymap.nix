{
  flake.nixosModules.keymap = {
    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "colemak_dh";
      options = "ctrl:swapcaps";
    };

    # also configure the console keymap
    console.keyMap = "mod-dh-ansi-us";
  };

  flake.homeModules.keymap = {
    home.keyboard = {
      layout = "us";
      options = [
        "ctrl:swapcaps"
      ];
      variant = "colemak_dh";
    };

    dconf = {
      settings = {
        "org/gnome/desktop/input-sources" = {
          xkb-options = [
            "ctrl:swapcaps"
          ];
        };
        # Use Emacs keybindings in GTK Applications
        "org/gnome/desktop/interface" = {
          gtk-key-theme = "Emacs";
        };
      };
    };
  };
}
