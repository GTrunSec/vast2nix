{
  inputs,
  cell,
} @ args: let
  inherit (inputs.cells-lab._writers.library) writeShellApplication;
  inherit (inputs) nixpkgs;
in {
  cli-doc = let
    cli = import ./cli-doc.nix args;
  in
    writeShellApplication {
      name = "deploy-user";
      runtimeInputs = [nixpkgs.glow];
      text = cli;
    };
}
