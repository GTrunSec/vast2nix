{
  inputs,
  cell,
}: {
  default = _: {
    commands = [
      {
        name = "vast-example";
        category = "conf";
        command = "vast --config=$PRJ_ROOT/conf/config.vast.example.yaml start";
        help = "launch vast with example.yaml";
      }
      {
        name = "nvfetcher-update";
        command = ''
          nix develop github:GTrunSec/cells-lab#devShells.x86_64-linux.update \
          --refresh --command \
          nvfetcher-update nix/vast/packages/sources.toml
        '';
        help = "update vast toolchain with nvfetcher";
      }
    ];
    packages = [
      inputs.cells.vast.packages.vast-integration
    ];
  };
}
