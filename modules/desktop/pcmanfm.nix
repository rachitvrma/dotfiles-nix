{
  flake.nixosModules.pcmanfm = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      pcmanfm
      shared-mime-info
      lxmenu-data
      ntfsprogs
    ];
  };
}
