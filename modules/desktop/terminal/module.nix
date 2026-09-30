let
  commonSetup = {
    xdg.terminal-exec = {
      enable = true;
      settings = {
        default = [ "footclient.desktop" ];
      };
    };
  };
in
{
  flake = {
    nixosModules.xdg-terminal = commonSetup;
    homeModules.xdg-terminal = commonSetup;
  };
}
