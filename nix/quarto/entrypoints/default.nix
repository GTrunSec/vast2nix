{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells-lab.writers.lib) writeShellApplication;

  l = inputs.nixpkgs.lib // builtins;
in {
  blog = writeShellApplication {
    name = "blog";
    runtimeInputs = [cell.packages.blog.rEnv nixpkgs.quarto cell.packages.blog.pythonEnv];
    runtimeEnv = {
      QUARTO_PYTHON = "${l.getExe cell.packages.blog.pythonEnv}";
      QUARTO_R = "${l.getExe cell.packages.blog.rEnv}";
    };
    text = ''
      quarto render "$@"
    '';
  };
}
