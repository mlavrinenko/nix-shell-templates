let
    mozilla = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
    nixpkgs = import <nixpkgs> { overlays = [ mozilla ]; };
in with nixpkgs;
let cargoDeps = [ rustc cargo pkg-config ];
    appDeps = [];
in mkShell rec {
    buildInputs = cargoDeps ++ appDeps;
    LOCALE_ARCHIVE  = "${glibcLocales}/lib/locale/locale-archive";
    LD_LIBRARY_PATH = "${lib.makeLibraryPath appDeps}";
    PKG_CONFIG_PATH = "${lib.makeSearchPathOutput "pkgconfig" "lib/pkgconfig" appDeps}:${LD_LIBRARY_PATH}";
    RUST_BACKTRACE  = 1;
}
