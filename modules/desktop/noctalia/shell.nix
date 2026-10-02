{
  flake.nixosModules.noctalia =
    { ... }:
    {
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        recommendedServices.enable = true;
      };
    };
  flake.homeModules.noctalia =
    {
      pkgs,
      lib,
      ...
    }:
    {
      home.packages = with pkgs; [
        # For external monitors, if the need ever arises
        ddcutil
        ddcutil-service
        ddcui
      ];

      # Integrate accounts and calendar.
      accounts.calendar.accounts.Personal.noctalia.enable = true;

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = lib.mkMerge [
          (lib.importTOML ./noctalia-config.toml)
          {
            # Disable templates coz we gonna use stylix
            theme.templates = {
              enable_builtin_templates = false;
              enable_community_templates = false;
            };
          }
        ];
      };
    };
}
