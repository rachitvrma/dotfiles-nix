{
  flake.homeModules.qutebrowser = {
    programs.qutebrowser =
      let
        esc_bind = "clear-keychain ;; search ;; fullscreen --leave";
      in
      {
        enable = true;
        loadAutoconfig = false;

        # NOTE: enableDefaultBindings = false would wipe
        # c.bindings.default for *every* mode, not just normal (see
        # earlier discussion). We only want normal cleared, so that's
        # done via extraConfig below instead.

        settings = {
          editor.command = [
            "emacsclient"
            "-c"
            # qutebrowser rejects empty-string list items outright, so
            # the separate "-a" "" pair doesn't validate. Folding the
            # empty value into the flag itself keeps it one non-empty
            # token while still passing "" as the alternate-editor value.
            "--alternate-editor="
            "{}"
          ];

          # Was mistakenly nested under `bindings.input` - that's not
          # a real qutebrowser setting path. This is `input.*`.
          input = {
            insert_mode = {
              auto_enter = false;
              auto_leave = false;
              plugins = false;
            };
            forward_unbound_keys = "all";
          };

          content = {
            javascript.modal_dialog = true;
            blocking.whitelist = [ ];
          };

          completion.height = "30%";
        };

        # Restores the "clean slate for normal mode only" intent -
        # hint/insert/command/prompt/caret keep their built-in
        # defaults except where explicitly overridden below.
        extraConfig = ''
          c.bindings.default['normal'] = {}
        '';

        keyBindings = {
          normal = {
            # Navigation
            "<ctrl-v>" = "scroll-page 0 0.5";
            "<alt-v>" = "scroll-page 0 -0.5";
            "<ctrl-shift-v>" = "scroll-page 0 1";
            "<alt-shift-v>" = "scroll-page 0 -1";
            "<alt-shift-,>" = "scroll-to-perc 0";
            "<alt-shift-.>" = "scroll-to-perc";
            # FIXME: come up with logical bindings for scrolling left/right

            "<ctrl-x><ctrl-f>" = "cmd-set-text -s :open -t";
            "<ctrl-u><ctrl-x><ctrl-f>" = "cmd-set-text -s :open";
            "<ctrl-x>l" = "reload";
            "<ctrl-x>xg" = "config-source";

            # Ctrl-M == Return in ASCII, so this is a *normal*-mode
            # binding, not an insert-mode one, despite sitting next to
            # the insert-mode block in the source.
            "<ctrl-m>" = "mode-enter insert";

            "<ctrl-x>0" = "tab-close";
            "<ctrl-x>1" = "tab-only";
            "<alt-a>" = "tab-prev";
            "<alt-e>" = "tab-next";

            "<ctrl-space>" = "hint all";
            "<ctrl-u><ctrl-space>" = "hint --rapid links tab-bg";

            # Commands
            "<alt-x>" = "cmd-set-text :";
            # NOTE: `buffer` is a deprecated alias for `tab-select`;
            # this only prefills the command line so it still works.
            "<ctrl-x>b" = "cmd-set-text -s :buffer";
            "<ctrl-x>k" = "tab-close"; # redundant with <ctrl-x>0, harmless
            "<ctrl-x><ctrl-c>" = "quit";

            # Searching
            "<ctrl-s>" = "cmd-set-text /";
            "<ctrl-r>" = "cmd-set-text ?";

            "<alt-w>" = "yank";
            "<ctrl-u><alt-w>d" = "yank domain";
            "<ctrl-u><alt-w>p" = "yank pretty-url";
            "<ctrl-u><alt-w>t" = "yank title";

            # Note that these bindings are quite dissimilar from other bindings
            "<Ctrl+/>v" = "spawn --detach mpv {url}";
            "<Ctrl+/>V" = "hint links spawn --detach mpv {hint-url}";

            # History
            "<ctrl-]>" = "forward";
            "<ctrl-[>" = "back";

            # Tabs
            "<ctrl-tab>" = "tab-next";
            "<ctrl-shift-tab>" = "tab-prev";

            # Open links
            "<ctrl-l>" = "cmd-set-text -s :open";
            "<alt-l>" = "cmd-set-text -s :open -t";

            # Editing
            "<ctrl-f>" = "fake-key <Right>";
            "<ctrl-b>" = "fake-key <Left>";
            "<ctrl-a>" = "fake-key <Home>";
            "<ctrl-e>" = "fake-key <End>";
            "<ctrl-n>" = "fake-key <Down>";
            "<ctrl-p>" = "fake-key <Up>";
            "<alt-f>" = "fake-key <Ctrl-Right>";
            "<alt-b>" = "fake-key <Ctrl-Left>";
            "<ctrl-d>" = "fake-key <Delete>";
            "<alt-d>" = "fake-key <Ctrl-Delete>";
            "<alt-backspace>" = "fake-key <Ctrl-Backspace>";
            "<ctrl-w>" = "fake-key <Ctrl-backspace>";
            "<ctrl-y>" = "insert-text {primary}";

            # Numbers
            # https://github.com/qutebrowser/qutebrowser/issues/4213
            "1" = "fake-key 1";
            "2" = "fake-key 2";
            "3" = "fake-key 3";
            "4" = "fake-key 4";
            "5" = "fake-key 5";
            "6" = "fake-key 6";
            "7" = "fake-key 7";
            "8" = "fake-key 8";
            "9" = "fake-key 9";
            "0" = "fake-key 0";

            # Escape hatch
            "<ctrl-h>" = "cmd-set-text -s :help";
            "<ctrl-g>" = esc_bind;
          };

          insert = {
            "<ctrl-e>" = "open-editor";
            "<escape>" = "mode-leave";
            "<ctrl-g>" = "mode-leave";
          };

          command = {
            "<ctrl-s>" = "search-next";
            "<ctrl-r>" = "search-prev";

            "<ctrl-p>" = "completion-item-focus prev";
            "<ctrl-n>" = "completion-item-focus next";

            "<alt-p>" = "command-history-prev";
            "<alt-n>" = "command-history-next";

            "<ctrl-g>" = "mode-leave";
            "<escape>" = "mode-leave";

            "<return>" = "command-accept";
            "<ctrl-m>" = "command-accept";
          };

          hint = {
            "<escape>" = "mode-leave";
            "<ctrl-g>" = "mode-leave";
            "<return>" = "follow-hint";
            "<ctrl-m>" = "follow-hint";
          };

          prompt = {
            "<ctrl-p>" = "prompt-item-focus prev";
            "<ctrl-n>" = "prompt-item-focus next";

            "<ctrl-g>" = "mode-leave";
            "<escape>" = "mode-leave";

            "<ctrl-m>" = "prompt-accept";
            "<return>" = "prompt-accept";

            "n" = "prompt-accept no";
            "y" = "prompt-accept yes";
          };

          caret = {
            "<ctrl-g>" = "mode-leave";
          };
        };

        searchEngines = {
          w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
          aw = "https://wiki.archlinux.org/?search={}";

          # Nix stack
          nw = "https://wiki.nixos.org/index.php?search={}";
          no = "https://search.nixos.org/options?channel=unstable&query={}";
          np = "https://search.nixos.org/packages?channel=unstable&query={}";

          g = "https://www.google.com/search?hl=en&q={}";
        };

        quickmarks = {
          claude = "https://claude.ai/";
          ghn = "https://github.com/notifications";
          ghdots = "https://github.com/rachitvrma/dotfiles";
        };
      };
  };
}
