{
  inputs,
  cell,
}: let
  inherit (inputs.cells.vast.lib) __inputs__;
in {
  quarto = __inputs__.dc.x86_64-linux.quarto.lib.mkEnv {
    r = ps:
      with ps; [
        # add your custom R packages here
        ggplot2
      ];
    python = ps:
      with ps; [
        # add your custom Python packages here
        pandas
      ];
    text = ''
      # write your custom bash script here
      quarto render "$@"
    '';
  };
}
