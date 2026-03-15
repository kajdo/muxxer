{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    python310
    python310Packages.pip
    python310Packages.virtualenv
    python310Packages.ipython
    python310Packages.black
    python310Packages.pytest
  ];

  shellHook = ''
    export PYTHONPATH="''${PWD}/src:$PYTHONPATH"
    echo "🐍 Python 3.10 environment ready!"
    echo "   Python: $(python --version)"
  '';
}
