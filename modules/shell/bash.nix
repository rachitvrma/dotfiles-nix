{
  flake = {
    nixosModules.bash = {
      environment.pathsToLink = [ "/share/bash-completion" ];
      programs = {
        bash = {
          enable = true;
          undistractMe = {
            enable = true;
            playSound = true;
          };
          # enableLsColors = true; # Incompatible with vivid
          completion.enable = true;
        };
      };
    };
    homeModules = {
      bash = {
        programs = {
          readline = {
            enable = true;
            variables = {
              expand-tilde = true;

              # https://wiki.archlinux.org/title/Readline
              colored-stats = true;
              visible-stats = true;
              mark-symlinked-directories = true;
              colored-completion-prefix = true;
              menu-complete-display-prefix = true;
              echo-control-characters = true;
            };
            includeSystemConfig = true;
          };
          bash = {
            enable = true;
            shellOptions = [
              "histappend"
              "extglob"
              "globstar"
              "checkjobs"
              "cdspell"
            ];
            historyIgnore = [
              "ls"
              "cd"
              "exit"
            ];
            historyControl = [
              "erasedups"
            ];
          };
        };
      };
    };
  };
}
