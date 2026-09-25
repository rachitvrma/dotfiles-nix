let
  commonSetup = {
    xdg.terminal-exec = {
      enable = true;
      settings = {
        default = [ "kitty.desktop" ];
      };
    };
  };
in
{
  flake.nixosModules.xdg-terminal = commonSetup;
  flake.homeModules.xdg-terminal = commonSetup;
}
