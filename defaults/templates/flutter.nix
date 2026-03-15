{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    flutter
    dart
  ];

  shellHook = ''
    echo "🦋 Flutter development environment ready!"
    echo "   Flutter: $(flutter --version | head -n 1)"
    echo "   Dart: $(dart --version 2>&1)"
  '';
}
