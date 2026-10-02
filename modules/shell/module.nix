{
  flake.nixosModules.shell = {
    programs = {
      comma = {
        enable = true;

      };
      television = {
        enable = true;

      };
      zoxide = {
        enable = true;

      };
      bat = {
        enable = true;
        settings = {
          italic-text = "always";
          pager = "less";
          paging = "never";
        };
      };
      vivid.enable = true;
    };
  };

  flake.homeModules.shell = { pkgs, ... }: {
    home = {
      shell = {
        enableBashIntegration = true;
        enableShellIntegration = true;
      };

      shellAliases = {
        ".." = "cd ..";
        ff = "${pkgs.fastfetch}/bin/fastfetch";
        nos = "nh os switch";
        nca = "nh clean all";
        cat = "bat --paging=never";
        sl = "sl -dFGl";
      };

      packages = with pkgs; [
        figlet
        sl
        speedtest-cli
        # See the systemd service and timer that cleans trash every 30 days
        trash-cli
        jdupes
        gdu
      ];
    };

    editorconfig = {
      enable = true;
      # root = true is added automatically by the module -- do not set it here.
      settings = {
        "*" = {
          charset = "utf-8";
          end_of_line = "lf";
          insert_final_newline = true;
          trim_trailing_whitespace = true;
          indent_style = "space";
          indent_size = 2;
          max_line_length = 100;
        };

        # Tab-indented languages/formats
        "*.{go,mk,Makefile}" = {
          indent_style = "tab";
        };
        "Makefile" = {
          indent_style = "tab";
        };

        # C/C++ -- 4-space is the more common convention there
        "*.{c,h,cpp,hpp,cc,cxx}" = {
          indent_size = 4;
        };

        # Python -- PEP 8
        "*.py" = {
          indent_size = 4;
          max_line_length = 88;
        };

        # Nix -- nixfmt/alejandra convention
        "*.nix" = {
          indent_size = 2;
        };

        # Lua
        "*.lua" = {
          indent_size = 2;
        };

        # Markdown -- trailing whitespace is sometimes meaningful (hard line breaks)
        "*.md" = {
          trim_trailing_whitespace = false;
          max_line_length = "off";
        };

        # Data/config formats
        "*.{json,yaml,yml,toml}" = {
          indent_size = 2;
        };

        # Diffs/patches -- never touch whitespace in these
        "*.{diff,patch}" = {
          trim_trailing_whitespace = false;
          insert_final_newline = false;
        };
      };

    };

    programs = {
      pay-respects = {
        # TODO: Configure this.
        enable = true;

      };
      devenv = {
        enable = true;

      };
      jq.enable = true;
      bat = {
        enable = true;
        config = {
          map-syntax = [
            "*.ino:C++"
            ".ignore:Git Ignore"
            "*.jenkinsfile:Groovy"
            "*.props:Java Properties"
          ];
          pager = "less -FR";
        };
      };

      tealdeer = {
        enable = true;
        settings.updates.auto_update = true;
      };

      nix-your-shell = {
        enable = true;

        nix-output-monitor.enable = true;
      };

      carapace = {
        enable = true;

      };

      fd.enable = true;

      eza = {
        enable = true;
        colors = "auto";

        git = false; # Takes really long to load big git repos
        icons = "auto";
        extraOptions = [
          # "--git-repos" # Takes too long to load on big repos
          "--group-directories-first"
          "--header"
        ];
      };

      vivid = {
        enable = true;
        colorMode = "24-bit";

      };

      fzf = {
        enable = true;

        defaultOptions = [
          "--height 40%"
          "--prompt ⟫"
        ];
      };

      ripgrep = {
        enable = true;
      };

      television = {
        enable = true;

        extraPackages = with pkgs; [
          poppler-utils # for pdftotext command
          figlet # for figlet-fonts
        ];
      };

      nix-search-tv = {
        enable = true;
        enableTelevisionIntegration = true;
        settings = {
          indexes = [
            "nixpkgs"
            "home-manager"
            "nixos"
            "nur"
            "noogle"
          ];
        };
      };

      zoxide = {
        enable = true;

      };
    };

    # Systemd settings to clean out trash regularly
    systemd.user = {
      services.trash-empty = {
        Unit.Description = "Empty trash older than 30 days";
        Service = {
          Type = "oneshot";
          # `-f` flag force removes trash without asking for confirmation
          # which makes sense, right?
          ExecStart = "${pkgs.trash-cli}/bin/trash-empty -f 30";
        };
      };
      timers.trash-empty = {
        Unit.Description = "Empty trash older than 30 days daily";
        Timer = {
          OnCalendar = "daily";
          Persistent = true;
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
  };
}
