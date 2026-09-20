{
  flake.homeModules.impala = { lib, ... }: {
    programs.impala = {
      enable = true;
      settings = lib.importTOML ./impala.toml;
    };
  };
}
