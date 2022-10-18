{
  inputs,
  cell,
}: let
  inherit (inputs) std self;
in {
  dev = std.lib.ops.mkDevOCI {
    name = "docker.io/quarto-dev";
    tag = self.lastModifiedDate;
    devshell = cell.devshells.blog;
    labels = {
      title = "quarto-dev";
      version = self.lastModifiedDate;
      url = "https://quarto.org";
      source = "https://github.com/tenzir/vast/tree/master/web/blog/a-git-retrospective";
      description = ''
        A prepackaged container for running quarto
      '';
    };
  };
}
