# Templates

Templates are pre-configured files copied into new projects.

## Template Location

```
~/.config/muxxer/shell-templates/
  python310.nix
  python312.nix
  bash.nix
  go.nix
  flutter.nix
  README.md.template
```

## shell.nix Templates

Templates are copied directly without modification. Any valid `shell.nix` can be a template.

### Example: python312.nix

```nix
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
    export PYTHONPATH="${PWD}/src:$PYTHONPATH"
    echo "Python environment ready!"
    echo "   Python: $(python --version)"
  '';
}
```

### Adding Custom Templates

1. Create a new `.nix` file in `~/.config/muxxer/shell-templates/`:

```bash
cat > ~/.config/muxxer/shell-templates/node.nix << 'EOF'
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    nodejs_20
    nodePackages.npm
    nodePackages.pnpm
  ];

  shellHook = ''
    echo "Node $(node --version) ready"
  '';
}
EOF
```

2. The template appears in the selection menu when creating a new repo

## README Template

The `README.md.template` uses simple variable substitution:

```markdown
# {repo_name}

TODO: Add project description

## Getting Started

`bash
# Enter development environment (if shell.nix exists)
nix-shell
`

## Development

TODO: Add development instructions

---

Created by muxxer
```

Only `{repo_name}` is substituted with the actual repository name.

### Customizing README Template

Edit `~/.config/muxxer/shell-templates/README.md.template`:

```markdown
# {repo_name}

## Setup

1. Enter nix-shell: `nix-shell`
2. Install dependencies: `make install`
3. Run: `make dev`

## License

MIT
```

## Built-in Templates

| Template | Description |
|----------|-------------|
| `python310.nix` | Python 3.10 with pip, virtualenv, ipython, black, pytest |
| `python312.nix` | Python 3.12 with pip, virtualenv, ipython, black, pytest |
| `bash.nix` | Basic bash environment |
| `go.nix` | Go development environment |
| `flutter.nix` | Flutter mobile development |

## Template Selection

When creating a new repository, muxxer shows all `.nix` files from the templates directory. Select one with fzf.

The preview shows the full template content so you can review before selecting.
