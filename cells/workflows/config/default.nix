{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab.makes.library) makeSubstitution;
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.lock) deploy;

  nix-expr = _args: import ./deploy-nix.nix _args;
  nodes-expr-env = import ./deploy-env.nix;
  nodes-args = builtins.listToAttrs (map (name: {
    value = {
      command = "./\${VERSION}-deploy/bin/\${VERSION}.deploy";
      args = ["-s" "\${HOST${toString name}}" "-o" "\{SSH_OPT${toString name}" "-d" "\${DIR ${toString name}" "-u"];
    };
    name = "deploy-${toString name}";})
    # how many machines ?
    (lib.range 1 deploy.nodes.config.hosts.count)
  );

  deploy-nix = nix-expr {
    env = "custom";
    args = ["-s" "root@192.168.122.126" "-o" "-p 22" "-d" "/opt/vast" "-u"];
  };
  main =
    {
      all = {
        dependencies = ["bundle" "deploy" "clean"];
      };
      clean = {
        command = "find";
        args = ["." "-iname" "*-deploy" "-type" "l" "-delete"];
      };
    };
in {
  default.tasks = {      env = {
        script = ''
        echo ''${TEST1} ${toString deploy.nodes.config.hosts.count}
        '';
      };
};
  nodes-env = main // nodes-args // nodes-expr-env;
}
