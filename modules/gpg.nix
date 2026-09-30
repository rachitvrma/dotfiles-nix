{
  flake = {
    nixosModules.gpg = { pkgs, ... }: {
      # Configure the agent using the home-manager modules.
      programs.gnupg = {
        dirmngr.enable = true;
        agent.pinentryPackage = pkgs.pinentry-emacs;
      };
    };

    homeModules.gpg = { pkgs, ... }: {
      programs = {
        gpg = {
          enable = true;
          settings = {
            personal-cipher-preferences = "AES256 AES192 AES";
            personal-digest-preferences = "SHA512 SHA384 SHA256";
            default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
            cert-digest-algo = "SHA512";
            s2k-digest-algo = "SHA512";
            s2k-cipher-algo = "AES256";
            charset = "utf-8";
            no-comments = true;
            no-emit-version = true;
            no-greeting = true;
            keyid-format = "0xlong";
            list-options = "show-uid-validity";
            verify-options = "show-uid-validity";
            with-fingerprint = true;
            require-cross-certification = true;
            no-symkey-cache = true;
            use-agent = true;
          };
        };
      };

      services.gpg-agent = {
        enable = true;
        enableScDaemon = false;
        enableSshSupport = true;
        defaultCacheTtl = 3600;
        maxCacheTtl = 86400;

        # TODO: These are emacs specific settings so they should be in Emacs module
        pinentry.package = pkgs.pinentry-emacs;
        extraConfig = ''
          allow-loopback-pinentry
          allow-emacs-pinentry
        '';
      };
    };
  };
}
