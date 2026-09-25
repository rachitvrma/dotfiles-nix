# Emacs packages not (yet) in nixpkgs, packaged here by hand.
#
# To add another one: drop a <name>.nix file next to this one (see
# xdg-launcher.nix for the shape -- a plain melpaBuild derivation), then
# list it below. `epkgs` is threaded through so each package definition
# gets melpaBuild/fetchFromGitHub/lib etc. via callPackage, same as any
# other emacsPackages derivation.
epkgs: with epkgs; [
  (callPackage ./_xdg-launcher.nix { })
  (callPackage ./_emacs-reader.nix { })
]
