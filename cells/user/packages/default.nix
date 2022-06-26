{
  inputs,
  cell,
}: let
  inherit (inputs) cells-lab;
  inherit (inputs) lock;
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.cells.vast.library) inputs';
in {
  env = cells-lab._builder.library.mkPaths {
    name = "env";
    paths =
      [
        # release latest bin
        inputs.cells.vast.packages.${lock.deploy.config.vast.version}
        # systemd.service
        cell.configFiles.systemd
        # # config file -> vast.yaml
        cell.configFiles.vast
      ]
      ++ lib.optionals lock.deploy.config.zeek.enable [
        inputs'.hunting-cells.zeek.packages.${lock.deploy.config.zeek.version}
      ]
      ++ lib.optionals lock.deploy.config.threatbus.enable [
        inputs'.hunting-cells.tenzir.packages.${lock.deploy.config.threatbus.version}
      ];
  };
}
