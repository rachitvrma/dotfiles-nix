{
  flake.nixosModules.xdg = {
    xdg = {
      icons = {
        enable = true;
      };
      mime.enable = true;
      menus.enable = true;
      sounds.enable = true;

      portal = {
        enable = true;
        xdgOpenUsePortal = true;
      };
    };

    environment = {
      localBinInPath = true;
      # NOTE: This is necessary, so don't remove it.
      # This is how NixOS and home-manager xdg outputs communicate
      pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];
    };
  };

  flake.homeModules.xdg = { config, ... }: {
    home.preferXdgDirectories = true;
    xdg = {
      enable = true;
      autostart.readOnly = true;
      localBinInPath = true;
      mime.enable = true;
      mimeApps = {
        enable = true;
        # TODO: Separate each of these in thier respective places
        defaultApplicationPackages = [
          config.programs.firefox.finalPackage # Covers html links
          config.programs.mpv.package # Covers audio/video
          config.programs.foliate.package # Covers pdfs and other kinda docs
        ];

        defaultApplications = {
          "image/jpeg" = "swayimg.desktop";
          "video/*" = "mpv.desktop";
          "application/vnd.comicbook+zip" = "org.pwmt.zathura.desktop";
        };
      };
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
      };
      userDirs = {
        enable = true;
        createDirectories = true;
        extraConfig = {
          MISC = "${config.home.homeDirectory}/Misc";
          NOTES = "${config.home.homeDirectory}/Notes";
        };
        setSessionVariables = true;
      };
    };
  };
}
