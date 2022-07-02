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
        category = "workflow";
      }
      {
        package = nixpkgs.just;
        category = "workflow";
      }
      {
        name = "cli-doc";
        command = "nix run github:gtrunsec/vast2nix#${nixpkgs.system}.query.entrypoints.cli-doc --refresh $@";
        help = "show vast cli-doc";
        category = "vast";
      }
    ];
  };
}
