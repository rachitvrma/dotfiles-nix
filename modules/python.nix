{
  flake.homeModules.python = { pkgs, ... }: {
    home.packages = [ pkgs.python315 ];
    programs = {
      ruff.enable = true;
      matplotlib = {
        enable = true;
        config = {
          axes = {
            edgecolor = "ff9900";
            facecolor = "black";
            grid = true;
          };
          backend = "TkAgg";
          grid = {
            color = "FF9900";
          };
        };
      };
      pylint.enable = true;
      uv.enable = true;
      pyenv.enable = true;
    };
  };
}
