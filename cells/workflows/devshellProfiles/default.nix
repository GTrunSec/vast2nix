{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  default = {...}: {
    commands = [
      {
        package = nixpkgs.cargo-make;
      }
      {
        name = "vast-deploy-nix";
        command = "nix run $PRJ_ROOT#${nixpkgs.system}.workflows.entrypoints.deploy-nix $@";
        help = "deploy the vast-env with nix expr";
      }
      {
        name = "vast-deploy";
        command = "nix run $PRJ_ROOT#${nixpkgs.system}.workflows.entrypoints.deploy $@";
        help = "deploy the vast-env with --env-file=<env.file>";
      }
    ];
  };
}
