{
  flake.homeModules.emacs =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      emacsFiles = [
        "init.el"
        "early-init.el"
      ];
      basePath = "${config.home.homeDirectory}/etc/nixos/modules/emacs/config";

      # Packages not (yet) in nixpkgs -- see packages/_default.nix.
      # Underscore-prefixes the *filename*, not the directory -- flake.nix's
      # isNixModule filter checks file.name only (recursively), so a
      # prefixed directory with unprefixed files inside is still auto-imported.
      manualEmacsPackages = import ./packages/_default.nix;
    in
    {
      stylix.targets.emacs.colors.enable = false;
      xdg.configFile = builtins.listToAttrs (
        map (name: {
          name = "emacs/${name}";
          value = {
            source = config.lib.file.mkOutOfStoreSymlink "${basePath}/${name}";
          };
        }) emacsFiles
      );

      home = {
        sessionVariables = {
          EDITOR = lib.mkForce "emacsclient -ca \"\"";
          VISUAL = lib.mkForce "emacsclient -ca \"\"";
        };
        packages = with pkgs; [
          nixd
          nixfmt

          guile-lsp-server # For guile scheme
          gnumake # For the make command

          tree-sitter # For cli installation of grammars

          systemd-lsp # for system stuff

          # Bash stack
          bash-language-server
          shfmt
          shellcheck

          vscode-langservers-extracted # HTML, CSS, SCSS, JSON
          typescript-language-server # Javascript
          clang-tools # C/C++ (clangd & clang-format)
          pyright # Python
          yaml-language-server
          taplo # TOML

          # For typst
          tinymist # the lsp server
          typst # The compiler binary
          typstyle # Formatter

          # Python stack
          python314Packages.jedi-language-server

          # LaTeX stack
          texlab
          zathura # Use this for viewing pdf files
          (texliveSmall.withPackages (
            ps: with ps; [
              scheme-medium
              latexmk
            ]
          ))

          # Aspell is also pulled in by kotatogram
          (aspellWithDicts (
            dicts: with dicts; [
              en
            ]
          ))

          # For restarting emacs immediately after rebuild
          (writeShellScriptBin "remacs" ''
            systemctl --user restart emacs.service
            echo "Emacs has been restarted!"
            echo
          '')
        ];
      };
      programs = {
        # Zathura setting to work with emacs LaTeX editing
        zathura.options.synctex-editor-command = "emacsclient +%{line} %{input}";

        emacs = {
          enable = true;
          package = pkgs.emacs-pgtk;
          extraPackages =
            epkgs:
            with epkgs;
            [
              ace-window
              apheleia
              aria2
              auctex # LaTeX stack

              # Avy collection
              avy
              avy-embark-collect
              avy-zap
              avy-act

              cdlatex # LaTeX stack
              breadcrumb # IDE like top bar for picking out symbols
              colorful-mode # Highlight Hex colors in programming modes
              consult # Completion engine for Emacs
              consult-eglot # Completion for LSP
              consult-eglot-embark
              consult-todo # Jump between TODO keywords
              corfu # Completion menu
              dash # Library functions
              dashboard # A nice startup screen
              diff-hl # See git hunks and changes in the line number area
              direnv # Load direnv stuff in emacs
              doom-modeline # A really cool modeline from the doom-emacs stack
              doom-themes # A collection of really great themes.
              edit-indirect # For editing different regions in different buffers
              editorconfig # Probably a built-in, but still
              eglot # Lsp server configuration, that's actually built-in
              embark
              embark-consult
              ement # Matrix client within emacs
              emms
              exec-path-from-shell
              forge # Github integration
              helpful # A better *help* buffer
              hl-todo # Highlight tags like TODO, etc.
              indent-bars
              jsdoc
              ligature
              magit
              majutsu
              marginalia
              multiple-cursors
              neotree # Side view stuff

              nerd-icons
              nerd-icons-completion
              nerd-icons-corfu
              nerd-icons-dired
              nerd-icons-grep
              nerd-icons-ibuffer
              nerd-icons-xref

              nix-mode # Nix src blocks require nix-mode to be present in the Emacs load path
              nix-ts-mode
              no-littering
              orderless
              org-auto-tangle
              page-break-lines
              password-store # An interface within emacs to interact with the GNU pass-cli
              pinentry # For pinentry
              pulsar # make it shine when you change point
              pyvenv # For working with python virtual environments
              rainbow-delimiters
              systemd # For systemd mode
              tramp # for TRAMP connection over ssh
              undo-fu # Part of undo-tree stack
              undo-fu-session # Part of undo-tree stack
              use-package
              vertico
              vundo # Part of undo-tree stack
              which-key
              zathura # Open links to documents in zathura
              zoxide

              # Tree-sitter grammars
              (treesit-grammars.with-grammars (
                grammars: with grammars; [
                  tree-sitter-bash
                  tree-sitter-c
                  tree-sitter-cpp
                  tree-sitter-css
                  tree-sitter-diff
                  tree-sitter-elisp
                  tree-sitter-fennel
                  tree-sitter-gitattributes
                  tree-sitter-git-config
                  tree-sitter-gitignore
                  tree-sitter-glsl
                  tree-sitter-html
                  tree-sitter-javascript
                  tree-sitter-jjdescription
                  tree-sitter-jsdoc
                  tree-sitter-json
                  tree-sitter-kdl
                  tree-sitter-latex
                  tree-sitter-lua
                  tree-sitter-markdown
                  tree-sitter-markdown-inline
                  tree-sitter-mermaid
                  tree-sitter-nix
                  tree-sitter-python
                  tree-sitter-regex
                  tree-sitter-ron
                  tree-sitter-scheme
                  tree-sitter-scss
                  tree-sitter-shellcheckrc
                  tree-sitter-svelte
                  tree-sitter-toml
                  tree-sitter-tsx
                  tree-sitter-typst
                  tree-sitter-vue
                  tree-sitter-xml
                  tree-sitter-yaml
                ]
              ))
            ]
            ++ manualEmacsPackages epkgs;
        };
      };
      services.emacs = {
        enable = true;
        defaultEditor = true;
        client = {
          enable = true;
          arguments = [
            "-c"
            "-a"
            "emacs"
          ];
        };
        startWithUserSession = "graphical";
      };
    };
}
