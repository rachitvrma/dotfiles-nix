# Remember to change the default xdg-terminal-exec
{
  flake.homeModules.foot = {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main.pad = "20x20 center-when-maximized-and-fullscreen";
      };
    };
  };
}
