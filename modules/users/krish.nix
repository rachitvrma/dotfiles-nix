{
  flake = {
    nixosModules.krish = { ... }: {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      users = {
        users."krish" = {
          isNormalUser = true;
          group = "krish";
          description = "Rachit Kumar Verma";
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
          initialPassword = "1234";
        };
        groups.krish = {
          name = "krish";
          members = [ "krish" ];
        };
      };
    };
    homeModules.krish = {
      home = {
        username = "krish";
        homeDirectory = "/home/krish";
        stateVersion = "26.05";
      };

      programs.home-manager.enable = true;
    };
  };
}
