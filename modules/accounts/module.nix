{
  flake.homeModules.email = { pkgs, ... }: {
    programs = {
      password-store = {
        enable = true;
        package = pkgs.pass-wayland;
      };
    };
    accounts = {
      calendar.basePath = ".calendar";
      email.accounts.Personal = {
        realName = "Rachit Kumar Verma";
        address = "rachitverma1122@gmail.com";
        primary = true;
        flavor = "gmail.com";
        passwordCommand = "pass show email/gmail";
      };
    };
  };
}
