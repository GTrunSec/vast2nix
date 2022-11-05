{
  inputs,
  cell,
} @ args: let
  inherit (inputs.cells-lab.makes.lib) makeSubstitution;
  inherit (inputs.cells-lab.common.lib) __inputs__;

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
  #deploy = utils;
  deploy = __inputs__.xnlib.lib.recursiveMerge [(import ./deploy.nix args) utils];

  watchexec-systemd = env:
    makeSubstitution {
      name = "watchexec-systemd";
      inherit env;
      source = ../configFiles/watchexec/systemd.service;
    };
}
