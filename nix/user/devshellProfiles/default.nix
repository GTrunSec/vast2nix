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
      # {
      #   name = "config";
      #   command = "nix run $PRJ_ROOT#${nixpkgs.system}.vast.configFiles.deploy-user $@";
      #   help = "deploy the vast-env with nix expr";
      # }
    ];
  };
  user = {...}: {
    commands = [
      {
        package = inputs.cells.vast.packages.vast-integration;
      }
      {
        package = nixpkgs.just;
        category = "workflow";
      }

      {
        package = inputs.cells.vast.packages.vast-release;
      }
      {
        name = "vast-doc";
        command = "nix run github:gtrunsec/vast2nix#${nixpkgs.system}.vast.entrypoints.doc --refresh --no-write-lock-file $@";
        help = "show vast vast-doc";
        category = "vast";
      }
    ];
  };
}
