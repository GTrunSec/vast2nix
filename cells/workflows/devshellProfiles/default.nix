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
  user = {...}: {
    commands = [
      {
        package = nixpkgs.cargo-make;
      }
      {
        name = "deploy";
        command = "nix run github:gtrunsec/vast2nix#${nixpkgs.system}.workflows.entrypoints.deploy-user --refresh $@";
        help = "deploy the vast-env";
      }
      {
        name = "review-deploy-config";
        command = "nix run github:gtrunsec/vast2nix#${nixpkgs.system}.workflows.configFile.deploy-user --refresh $@";
        help = "deploy the vast-env";
      }
    ];
  };
}
