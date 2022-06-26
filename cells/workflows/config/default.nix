{
  inputs,
  cell,
} @ args: let
  inherit (inputs.cells-lab.makes.library) makeSubstitution;
  inherit (inputs.cells-lab.main.library) inputs';

  nix-expr = _args: import ./deploy-nix.nix _args;
  deploy-nix = nix-expr {
    env = "custom";
    args = ["-s" "root@192.168.122.126" "-o" "-p 22" "-d" "/opt/vast" "-u"];
  };
  main = {
    clean = {
      command = "find";
      args = ["." "-iname" "*-deploy" "-type" "l" "-delete"];
    };
  };
in {
  default = main;
  deploy-user = inputs'.xnlib.lib.recursiveMerge [(import ./deploy-user.nix args) main];
}
