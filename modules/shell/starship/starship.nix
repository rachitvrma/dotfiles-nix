{
  flake = {
    nixosModules.starship = {
      programs.starship = {
        enable = true;
        transientPrompt.enable = true;
        settings = {
          scan_timeout = 10;
          add_newline = true;
          command_timeout = 200;
        };
      };
    };
    homeModules.starship = { lib, ... }: {
      programs.starship = {
        enable = true;
        presets = [ "pure-preset" ];
        settings = lib.mkAfter (lib.importTOML ./starship.toml);
      };
    };
  };
}
