# Regular shell
# $ nix-shell
# Shell with xdebug enabled
# $ nix-shell --arg debug true

{ debug ? false, pkgs ? import <nixpkgs> {} }:
with pkgs;
let php = php74.withExtensions ({ all, enabled }: with all; [ opcache json xdebug ] ++ enabled);
in mkShell {
    buildInputs = [ php php.packages.composer nodejs-14_x ];
    XDEBUG_MODE = "debug";
    XDEBUG_CONFIG = lib.optional debug "idekey=PHPSTORM remote_enable=1";
    PHP_IDE_CONFIG = "serverName=localhost";
    LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive";
    shellHook = ''
        PATH="bin:vendor/bin:$PATH"
    '';
}
