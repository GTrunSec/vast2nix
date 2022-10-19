{
  inputs = {
    hunting-cells.url = "github:gtrunsec/hunting-cells";
    nixpkgs-hardenedlinux.url = "github:hardenedlinux/nixpkgs-hardenedlinux";
    # dc.url = "github:gtrunsec/data-science-threat-intelligence";
    dc.url = "/home/gtrun/ghq/github.com/GTrunSec/data-science-threat-intelligence";
  };

  outputs = {self, ...}: {};
}
