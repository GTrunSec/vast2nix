{
  inputs,
  cell,
} @ args: let
  inherit (inputs.std) dmerge;
  inherit (cell) lib;
  inherit (inputs) nixpkgs std;
  inherit (inputs.cells-lab.main.lib) __inputs__;
  inherit (inputs.cells-lab.makes.lib) makeSubstitution;
  l = nixpkgs.lib // builtins;
in {
  default =
    cell.lib.mkConfig {
      dataDir = "/tmp/vast";
      verbosity = "debug";
    } {
      # add your custom settings here
      vast.store-backend = "archive";
    };

  validation-error =
    cell.lib.mkConfig {
      dataDir = "/tmp/vast";
      verbosity = "debug";
    } {
      # validation: error
      vast.store-backend = "archivee";
    };
}
