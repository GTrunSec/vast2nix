{
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  inputs.hunting-cells.url = "github:gtrunsec/hunting-cells";

  outputs = {self, ...}: {};
}
