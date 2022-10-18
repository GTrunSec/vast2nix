{
  inputs,
  cell,
}: let
  inherit (inputs) std self;

  labels = {
    title = "quarto-bin";
    version = "latest";
    url = "https://quarto.org";
    source = "https://github.com/tenzir/vast/tree/master/web/blog/a-git-retrospective";
    description = ''
      A prepackaged container for running quarto
    '';
  };
in {
  dev = std.lib.ops.mkDevOCI {
    name = "docker.io/quarto-dev";
    tag = "latest";
    devshell = cell.devshells.blog;
    labels = labels // {title = "quarto-dev";};
  };
  bin = std.lib.ops.mkStandardOCI {
    name = "docker.io/quarto-bin";
    tag = "latest";
    operable = cell.entrypoints.blog;
    labels = labels // {title = "quarto-bin";};
  };
}
