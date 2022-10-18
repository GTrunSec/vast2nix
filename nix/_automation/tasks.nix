{
  fmt = {
    description = "Formats all changed source files";
    content = ''
      treefmt $(git diff --name-only --cached)
    '';
  };
  doc = {
    description = "Show Vast documentation";
    args = ["help"];
    content = ''
      nix run $PRJ_ROOT\#x86_64-linux.vast.entrypoints.doc {{help}}
    '';
  };
}
