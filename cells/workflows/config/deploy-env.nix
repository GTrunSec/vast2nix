{
  bundle = {
    command = "nix";
    args = [
      "bundle"
      "--bundler"
      "github:Ninlives/relocatable.nix"
      "--refresh"
      ".#x86_64-linux.vast.packages.\${VERSION}"
    ];
  };
}
