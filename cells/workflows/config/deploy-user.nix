{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs) nixpkgs;
  inherit (inputs.lock) deploy;
  inherit (inputs.cells-lab.main.library) inputs';

  default .tasks = {
    bundle = {
      command = "nix";
      args = [
        "bundle"
        "--bundler"
        "github:Ninlives/relocatable.nix"
        "--refresh"
        "/home/gtrun/ghq/github.com/GTrunSec/vast2nix#${nixpkgs.system}.workflows.packages.user"
        #"github:gtrunsec/vast2nix#\${SYSTEM}.workflows.packages.user"
      ];
    };
    all = {
      dependencies = map (f: "deploy-${toString f}") (lib.range 1 deploy.config.info.machines);
    };
  };
  nodes.tasks = builtins.listToAttrs (
    map (name: {
      value = {
        command = "./user-deploy/bin/user.deploy";
        args = ["-s" "\${HOST${toString name}}" "-o" "\${SSH_OPT${toString name}}" "-d" "\${DIR${toString name}}" "-u"];
      };
      name = "deploy-${toString name}";
    })
    # how many machines ?
    (lib.range 1 deploy.config.info.machines)
  );
in
  inputs'.xnlib.lib.recursiveMerge [
    default
    nodes
  ]
