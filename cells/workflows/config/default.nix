{
  inputs,
  cell,
} @ args: let
  inherit (inputs.cells-lab.makes.library) makeSubstitution;
  nix-expr = _args: import ./deploy-nix.nix _args;

  deploy-nix = nix-expr {
    env = "custom";
    args = ["-s" "root@192.168.122.126" "-o" "-p 22" "-d" "/opt/vast" "-u"];
  };
  main = {
    all = {
      dependencies = ["bundle" "deploy" "clean"];
    };
    clean = {
      command = "find";
      args = ["." "-iname" "*-deploy" "-type" "l" "-delete"];
    };
  };
in {
  # nodes-env = main // nodes-args // nodes-expr-env;
  deploy-user = import ./deploy-user.nix args;
}
