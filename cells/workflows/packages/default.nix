{
  inputs,
  cell,
}: let
  inherit (inputs) cells-lab;
  inherit (inputs) lock;
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.cells.vast.library) inputs';
in {
  user = cells-lab._builder.library.mkPaths {
    name = "user";
    paths =
      [
        # release latest bin
        inputs.cells.vast.packages.${lock.deploy.config.vast.version}
        # systemd.service
        # inputs.cells.vast.configFiles.user-systemd
        # # config file -> vast.yaml
        # inputs.cells.vast.configFiles.user-config
      ]
      ++ lib.optionals lock.deploy.config.zeek.enable [
        inputs'.hunting-cells.zeek.packages.${lock.deploy.config.zeek.version}
      ]
      ++ lib.optionals lock.deploy.config.threatbus.enable [
        inputs'.hunting-cells.tenzir.packages.${lock.deploy.config.threatbus.version}
      ];
  };
}
