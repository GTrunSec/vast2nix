{
  inputs,
  cell,
}: let
  inherit (inputs) std nixpkgs;
  l = inputs.nixpkgs.lib // builtins;
in
  l.mapAttrs (_: std.lib.dev.mkShell) {
    blog = {...}: {
      name = "quarto-devshell";

      commands = [
        {
          package = nixpkgs.quarto;
        }
      ];

      packages = [
        cell.packages.blog.rEnv
        cell.packages.blog.pythonEnv
        nixpkgs.which
      ];

      env = [
        {
          name = "QUARTO_R";
          value = "${cell.packages.blog.rEnv}/bin/R";
        }
        {
          name = "QUARTO_PYTHON";
          value = "${cell.packages.blog.pythonEnv}/bin/python";
        }
      ];
    };
  }
