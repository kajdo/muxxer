{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    python312
    python312Packages.pip
    python312Packages.virtualenv
    python312Packages.ipython
    python312Packages.black
    python312Packages.pytest
  ];

  shellHook = ''
    export PYTHONPATH="''${PWD}/src:$PYTHONPATH"
    echo "🐍 Python environment ready!"
    echo "   Python: $(python --version)"
  '';
}
