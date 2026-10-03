{
  flake.homeModules.fastfetch = { lib, ... }: {
    programs.fastfetch = {
      enable = true;
      settings = lib.importJSON ./settings.json;
    };
  };
}
