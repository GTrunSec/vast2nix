{
  inputs,
  cell,
}: let
  inherit (inputs.cells.vast.lib) __inputs__;
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
  # quarto = __inputs__.dc.x86_64-linux.quarto.lib.mkEnv {
  #   r = ps:
  #     with ps; [
  #       # add your custom R packages here
  #       ggplot2
  #     ];
  #   python = ps:
  #     with ps; [
  #       # add your custom Python packages here
  #       pandas
  #     ];
  #   text = ''
  #     # write your custom bash script here
  #     quarto render "$@"
  #   '';
  # };
}
