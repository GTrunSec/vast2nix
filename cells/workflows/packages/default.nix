{
  inputs,
  cell,
}: let
  inherit (inputs) cells-lab;
  inherit (inputs.cell) vast;
  inherit (inputs) lock;
  inherit (inputs.nixpkgs) lib;
in {
  user = cells-lab._builder.library.mkPaths {
    name = "user";
    paths =
      [
        # release latest bin
        vast.packages.${lock.deploy.nodes.config.vast.version}
        # systemd.service
        cell.configFiles.customSystemd
        # config file -> vast.yaml
        cell.configFiles.customConfig
      ]
      ++ lib.optionals lock.deploy.nodes.config.zeek.enable [
        inputs.hunting-cells.zeek.packages.${lock.deploy.nodes.config.zeek.version}
      ]
      ++ lib.optionals lock.deploy.nodes.config.threatbus.enable [
        inputs.hunting-cells.zeek.packages.${lock.deploy.nodes.config.threatbus.version}
      ];
  };
}
