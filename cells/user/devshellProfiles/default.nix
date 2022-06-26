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
        command = "nix run $PRJ_ROOT#${nixpkgs.system}.user.entrypoints.deploy $@";
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
        package = nixpkgs.just;
      }
      {
        name = "deploy";
        command = "nix run github:gtrunsec/vast2nix#${nixpkgs.system}.user.entrypoints.deploy --refresh $@";
        help = "deploy the vast-env";
      }
      {
        name = "config";
        command = "nix run github:gtrunsec/vast2nix#${nixpkgs.system}.user.entrypoints.config --refresh $@";
        help = "deploy the vast-env";
      }
      {
        name = "just-dev";
        command = "just -f $PRJ_ROOT/devshell/justfile $@";
        help = "run just with dev-justfile";
      }
    ];
  };
}
