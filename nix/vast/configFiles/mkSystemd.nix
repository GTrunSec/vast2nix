{
  inputs,
  cell,
} @ args: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells-lab.makes.lib) makeSubstitution;

  l = nixpkgs.lib // builtins;

  systemd = env:
    makeSubstitution {
      name = "vast-systemd";
      inherit env;
      source = ./systemd.service;
    };
in
  systemd
