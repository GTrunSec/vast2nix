{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs std;
in
  l.mapAttrs (_: std.lib.dev.mkShell) {
    default = {lib, ...}: {
      name = "Vast2nix DevShell";

      imports = [
        inputs.cells-lab._automation.devshellProfiles.default

        cell.devshellProfiles.default
        inputs.cells.user.devshellProfiles.default
      ];

      nixago =
        []
        # ++ l.attrValues inputs.cells.schemas.nixago
        ++ l.attrValues inputs.cells._automation.nixago;
    };

    user = {lib, ...}: {
      name = "User: Vast2nix";
      imports = [
        inputs.cells-lab._automation.devshellProfiles.default
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
