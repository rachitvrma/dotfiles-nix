let
  shinchan =
    pkgs:
    pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/rachitvrma/rachitvrma/main/.github/assets/shinchan.png";
      hash = "sha256-CP9uGyslZ19wCaglMb1UG+NmcU/GxN5HDXSdrO5jAlw=";
    };
  commonDesktopEnvVars = {
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland,x11";
    CLUTTER_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = 1;
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    NIXOS_OZONE_WL = 1;
    WLR_NO_HARDWARE_CURSORS = 1;
    WLR_RENDERER = "vulkan";
    LIBVA_DRIVER_NAME = "iHD";
    GTK_USE_PORTAL = 1;
  };
in
{
  flake = {
    nixosModules.commonDesktop = { pkgs, ... }: {
      # For Avatar Image
      systemd.tmpfiles.rules = [
        "L+ /var/lib/AccountsService/icons/krish - - - - ${shinchan pkgs}"
        "f+ /var/lib/AccountsService/users/krish 0644 root root - [User]\\nIcon=/var/lib/AccountsService/icons/krish\\n"
      ];
      services = {
        seatd.enable = true;
        xserver.updateDbusEnvironment = true;
        udisks2.enable = true;
        gvfs = {
          enable = true;
        };
        playerctld.enable = true;
        devmon.enable = true;
      };
      security = {
        polkit.enable = true;
        pam.services = {
          greetd.enableGnomeKeyring = true;
          login.enableGnomeKeyring = true;
        };
      };
      # Essential variables for wayland set up
      environment.sessionVariables = commonDesktopEnvVars;
    };

    homeModules.commonDesktop = { pkgs, lib, ... }: {
      xdg.portal.enable = true;

      home.file.".face".source = shinchan pkgs;
      home.sessionVariables = lib.mkMerge [
        commonDesktopEnvVars
      ];
      systemd.user.sessionVariables.GDK_BACKEND = "wayland";
      services = {
        playerctld.enable = true;
        udiskie = {
          enable = true;
        };

        batsignal = {
          enable = true;
          extraArgs = [
            "-w"
            "50" # warning level
            "-c"
            "40" # critical level
            "-d"
            "30" # danger level
            # "-f"
            # "95" # full-battery notification (0 disables; 97-99 is the usual choice since some batteries never report exactly 100)
            "-m"
            "20" # min seconds between checks
          ];
        };
      };
    };
  };
}
