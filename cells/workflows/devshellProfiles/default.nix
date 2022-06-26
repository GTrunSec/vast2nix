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
        name = "deploy";
        command = "nix run $PRJ_ROOT#${nixpkgs.system}.workflows.entrypoints.deploy $@";
        help = "deploy the vast-env with nix expr";
      }
      {
        name = "config";
        command = "nix run $PRJ_ROOT#${nixpkgs.system}.vast.configFiles.deploy-user $@";
        help = "deploy the vast-env with nix expr";
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
        name = "config";
        command = "nix run github:gtrunsec/vast2nix#${nixpkgs.system}.workflows.entrypoints.deploy-user-config --refresh $@";
        help = "deploy the vast-env";
      }
    ];
  };
}
