{
  inputs,
  cell,
} @ args: let
  inherit (inputs) nixpkgs data-merge vast2nix;
  inherit (nixpkgs) lib;
  inherit (inputs.cells-lab.main.library) inputs';
in rec {
  #deploy = cell.library.toTOML cell.config.deploy;
  deploy = cell.library.toTOML cell.config.deploy-user;

  vast = inputs.cells.vast.library.toYaml (inputs'.xnlib.lib.recursiveMerge [
    (inputs.cells.vast.config.default {})
    (lib.importJSON (inputs.cells.vast.library.toJSON inputs.lock.deploy.vast.config))
  ]);

  systemd = (import ./custom.nix args).systemd;

  watchexec-zeek =
    nixpkgs.writers.writeBash "watchexec.bash"
    (import ./watchexec/zeek.nix {
      watchexec = cell.packages.watchexec-simple;
      endpoint = vast.vast.endpoint;
    });

  watchexec-systemd = cell.config.watchexec-systemd {
    __argScript__ = "/opt/vast-env/root/watchexec-zeek";
    __argDir__ = "/var/lib/zeek";
  };
}
