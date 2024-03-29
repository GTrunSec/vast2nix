{
  inputs,
  cell,
}: let
  inherit (inputs.cells.common.lib) __inputs__;
  inherit (inputs) nixpkgs;
in {
  blog.pythonEnv =
    nixpkgs.python3.buildEnv.override
    {
      extraLibs = with nixpkgs.python3Packages; [
        nbconvert
        ipykernel
        bash_kernel
        jupyter
      ];
    };
  blog.rEnv = nixpkgs.rWrapper.override {
    packages = with nixpkgs.rPackages; [
      dplyr
      ggplot2
      lubridate
      readr
      rmarkdown
      ggrepel
      tidyr
    ];
  };
}
