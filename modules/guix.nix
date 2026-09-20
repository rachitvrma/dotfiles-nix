{
  flake.nixosModules.guix = {
    services.guix = {
      enable = true;
      extraArgs = [
        "--max-jobs=4"
        "--debug"
      ];
      stateDir = "/gnu/var";
      gc = {
        enable = true;
        extraArgs = [
          "--delete-generations=1m"
          "--free-space=10G"
          "--optimize"
        ];
      };
    };
  };
  flake.homeModules.direnv = {
    # Somehow starship doesn't show the guix shell symbol, so this is the fix
    programs.direnv.stdlib = ''
      # ~/.config/direnv/direnvrc
      use_guix() {
        direnv_load guix shell "$@" -- "$direnv" dump
      }
    '';
  };
}
