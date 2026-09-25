{
  melpaBuild,
  fetchFromGitea,
  pkg-config,
  gcc,
  mupdf,
  gnumake,
}:

melpaBuild {
  ename = "reader";
  pname = "emacs-reader";
  version = "20250629";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "MonadicSheep";
    repo = "emacs-reader";
    rev = "a0e3615adbf520a5743bbbfd7da6d2bb8478b30b";
    hash = "sha256-wLtTuNPVDVGVa0fhC57DJfXjTFp2itxXJfw/XqgZUQQ=";
  };
  files = ''(:defaults "render-core.so")'';
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gcc
    mupdf
    gnumake
    pkg-config
  ];
  preBuild = "make clean all";

  # reader-bookmark.el / reader-outline.el / reader-saveplace.el each have
  # a top-level (require 'reader). During melpaBuild's ELPA-install step
  # the package's own directory isn't on load-path yet, so that require
  # fails and kills the build. Harmless at actual load time once the
  # package is installed/activated for real.
  ignoreCompilationError = true;
}
