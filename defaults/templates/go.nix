{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    go
    gopls
    delve
    gotools
  ];

  shellHook = ''
    echo "🐹 Go development environment ready!"
    echo "   Go: $(go version)"
  '';
}
