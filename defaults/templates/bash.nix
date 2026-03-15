{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    bashInteractive
    shellcheck
    shfmt
  ];

  shellHook = ''
    echo "🐚 Bash development environment ready!"
    echo "   Bash: $(bash --version | head -n 1)"
  '';
}
