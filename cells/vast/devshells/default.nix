{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs std;
in
  l.mapAttrs (_: std.std.lib.mkShell) {
    default = {lib, ...}: {
      name = "Std: Vast2nix";

      std.docs.enable = lib.mkForce true;

      imports = [
        inputs.cells-lab.main.devshellProfiles.default
        cell.devshellProfiles.default
        inputs.cells.user.devshellProfiles.default
      ];
      nixago = [cell.nixago.treefmt];
    };
    user = {lib, ...}: {
      name = "User: Vast2nix";

      std.docs.enable = lib.mkForce true;

      imports = [
        inputs.cells-lab.main.devshellProfiles.default
        inputs.cells.user.devshellProfiles.user
      ];
    };
    template = {lib, ...}: {
      name = "Template to Vast2nix";
      imports = [
        inputs.cells.user.devshellProfiles.user
      ];
    };
  }
