{ inputs, devshell, pkgs }:
devshell.mkShell {
  imports = [ (devshell.importTOML ./devshell.toml) ];
  commands = with pkgs;
    [
      {
        name = pkgs.vast-latest.pname;
        help = pkgs.vast-latest.meta.description;
        package = pkgs.vast-latest;
      }
    ];
}
