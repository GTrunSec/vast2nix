{
  inputs,
  cell,
} @ args: let
  inherit (inputs) nixpkgs data-merge vast2nix;
  inherit (nixpkgs) lib;
  inherit (inputs.cells-lab.main.lib) __inputs__;
in {
  deploy = inputs.cells-lab._writers.lib.writeConfig "user-deploy" "yaml" cell.config.deploy;

  vast = inputs.cells-lab._writers.lib.writeConfig "user-vast" "yaml" (__inputs__.xnlib.lib.recursiveMerge [
    (inputs.cells.vast.config.default {
      # catalog-fp-rate = 0.02;
    })
    (lib.importJSON (inputs.cells.vast.lib.toJSON inputs.lock.deploy.vast.config))
  ]);

  systemd = (import ./custom.nix args).systemd;

  watchexec-zeek =
    nixpkgs.writers.writeBash "watchexec.bash"
    (import ./watchexec/zeek.nix {
      watchexec = cell.packages.watchexec-simple;
      endpoint = (lib.importJSON (inputs.cells.vast.lib.toJSON inputs.lock.deploy.vast.config)).vast.endpoint;
    });

  watchexec-systemd = cell.config.watchexec-systemd {
    __argScript__ = "/opt/vast-env/root/watchexec-zeek";
    __argDir__ = "/var/lib/zeek";
  };
}
