{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs) nixpkgs;
  inherit (inputs.lock) deploy;
  inherit (inputs.cells-lab.common.lib) __inputs__;

  default.tasks = {
    bundle = {
      command = "nix";
      args = [
        "bundle"
        "--bundler"
        "github:Ninlives/relocatable.nix"
        "--refresh"
        #"/home/gtrun/ghq/github.com/GTrunSec/vast2nix#${nixpkgs.system}.user.packages.env"
        "github:gtrunsec/vast2nix#${nixpkgs.system}.user.packages.env"
        "--override-input"
        "lock"
        "./profiles/${deploy.dir}"
      ];
    };
    deploy.run_task = {
      name = map (f: "deploy-${toString f}") (lib.range 1 deploy.config.info.machines);
      parallel = true;
    };
    all = {
      dependencies = ["deploy" "clean"];
    };
  };
  nodes.tasks = builtins.listToAttrs (
    map (name: {
      value = {
        command = "./env-deploy/bin/env.deploy";
        args = [
          "-s"
          "\${HOST${toString name}}"
          "-o"
          "\${SSH_PORT${toString name}} \${SSH_OPT${toString name}}"
          "-d"
          "\${DIR${toString name}}"
          "-u"
        ];
        dependencies = ["bundle"];
      };
      name = "deploy-${toString name}";
    })
    # how many machines ?
    (lib.range 1 deploy.config.info.machines)
  );
  init-nodes.tasks = builtins.listToAttrs (
    map (name: let
      init-bash = ''
        <<'ENDSSH'
        DIR=''${DIR${toString name}}
        if [[ ! -d "''${DIR${toString name}}" ]]; then
           mkdir -p ''${DIR${toString name}}
        fi
        if [[ -f "$DIR/root/bin/zeek-config" && ! -d "/var/lib/zeek" ]]; then
           bash $DIR/root/pre-zeekctl.bash $DIR/root/bin
        fi
        ENDSSH
      '';
    in {
      value = {
        command = "ssh";
        args = [
          "\${HOST${toString name}}"
          "\${SSH_PORT${toString name}}"
          "\${SSH_OPT${toString name}}"
          "bash -s"
          "${init-bash}"
        ];
        # dependencies = ["deploy-${toString name}"];
      };
      name = "deploy-init-${toString name}";
    })
    # how many machines ?
    (lib.range 1 deploy.config.info.machines)
  );
in
  __inputs__.xnlib.lib.recursiveMerge [
    default
    nodes
    init-nodes
  ]
