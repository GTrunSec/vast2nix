{
  inputs,
  cell,
} @ args: let
  inherit (inputs.cells-lab.makes.library) makeSubstitution;
  inherit (inputs.cells-lab.main.library) inputs';

  nix-expr = _args: import ./deploy-nix.nix _args;
  deploy-nix =
    nix-expr {
    };
  utils.tasks = {
    clean = {
      command = "find";
      args = ["." "-iname" "*-deploy" "-type" "l" "-delete"];
    };
  };
in {
  deploy = utils;
  deploy-user = inputs'.xnlib.lib.recursiveMerge [(import ./deploy-user.nix args) utils];
}
