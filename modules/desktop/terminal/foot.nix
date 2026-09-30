{
  flake.homeModules.foot = {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main.pad = "15x15 center-when-maximized-and-fullscreen";
      };
    };
  };
}
