{
  inputs,
  cell,
} @ args: let
  inherit (inputs) nixpkgs data-merge vast2nix;
  inherit (nixpkgs) lib;
  inherit (inputs.cells-lab.main.library) __inputs__;
in {
  deploy = cell.library.toTOML cell.config.deploy;

  vast = inputs.cells.vast.library.toYaml (__inputs__.xnlib.lib.recursiveMerge [
    (inputs.cells.vast.config.default {
      # catalog-fp-rate = 0.02;
    })
    (lib.importJSON (inputs.cells.vast.library.toJSON inputs.lock.deploy.vast.config))
  ]);

  systemd = (import ./custom.nix args).systemd;

  watchexec-zeek =
    nixpkgs.writers.writeBash "watchexec.bash"
    (import ./watchexec/zeek.nix {
      watchexec = cell.packages.watchexec-simple;
      endpoint = (lib.importJSON (inputs.cells.vast.library.toJSON inputs.lock.deploy.vast.config)).vast.endpoint;
    });

  watchexec-systemd = cell.config.watchexec-systemd {
    __argScript__ = "/opt/vast-env/root/watchexec-zeek";
    __argDir__ = "/var/lib/zeek";
  };
}
