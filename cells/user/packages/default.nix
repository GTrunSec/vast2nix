{
  inputs,
  cell,
}: let
  inherit (inputs) cells-lab;
  inherit (inputs) lock nixpkgs;
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.cells.vast.library) __inputs__;
in {
  env = cells-lab._builder.library.mkPaths {
    name = "env";
    paths = lib.optionals lock.deploy.config.vast.enable [
        # release latest bin
        inputs.cells.vast.packages.${lock.deploy.config.vast.version}
        # systemd.service
        cell.configFiles.systemd
        # # config file -> vast.yaml
        cell.configFiles.vast
        # cat the logs to vast importer
        __inputs__.nixpkgs-hardenedlinux.packages.watchexec-simple
        cell.configFiles.watchexec-zeek
        cell.configFiles.watchexec-systemd
        nixpkgs.sd
        nixpkgs.file
      ]
      ++ lib.optionals lock.deploy.config.zeek.enable [
        __inputs__.hunting-cells.zeek.packages.${lock.deploy.config.zeek.version}
        __inputs__.hunting-cells.zeek.configFiles.pre-zeekctl
        __inputs__.nixpkgs-hardenedlinux.packages.watchexec-simple
      ]
      ++ lib.optionals lock.deploy.config.threatbus.enable [
        __inputs__.hunting-cells.tenzir.packages.${lock.deploy.config.threatbus.version}
      ];
  };
  inherit (__inputs__.nixpkgs-hardenedlinux.packages) watchexec-simple;
}
