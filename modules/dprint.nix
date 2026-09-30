# TODO: Needs an activation script so that plugins are updated everytime they run
{
  flake.homeModules.dprint = { pkgs, ... }: {
    programs.dprint = {
      enable = true;
      settings = {
        lineWidth = 80;
        markdown = {
          lineWidth = 80;
        };
        plugins = [
          "${pkgs.dprint-plugins.dprint-plugin-markdown}/plugin.wasm"
          "${pkgs.dprint-plugins.dprint-plugin-toml}/plugin.wasm"
          "${pkgs.dprint-plugins.dprint-plugin-json}/plugin.wasm"
          "${pkgs.dprint-plugins.g-plane-malva}/plugin.wasm"
          "${pkgs.dprint-plugins.g-plane-markup_fmt}/plugin.wasm"
          "${pkgs.dprint-plugins.g-plane-pretty_yaml}/plugin.wasm"
        ];
      };
    };
  };
}
