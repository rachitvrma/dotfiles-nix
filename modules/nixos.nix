{ self, inputs, ... }:
let
  dotfilesDir = "/home/krish/etc/nixos";
in
{
  flake.nixosConfigurations.nixpavilion = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self dotfilesDir; };
    modules =
      (builtins.attrValues self.nixosModules) # Import nixosModules
      ++ [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs self dotfilesDir; };
          home-manager.users.krish.imports = builtins.attrValues self.homeModules; # Import homeModules
          home-manager.backupFileExtension = "hm-bak";
        }
      ];

  };

  flake.nixosModules.nixos = { pkgs, ... }: {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05"; # Did you read the comment?

    home-manager.backupCommand = "${pkgs.trash-cli}/bin/trash";

    nixpkgs.overlays = [
      # Add in the NUR overlays.
      inputs.nur.overlays.default
    ];
  };
}
