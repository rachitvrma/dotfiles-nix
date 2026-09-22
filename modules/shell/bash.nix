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
    homeModules.bash = {
      programs.bash = {
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
}
