{
  inputs,
  cell,
} @ args: let
  inherit (cell.library) l;
  args' = args // {inherit l;};
in {
  mkModel = import ./mkModel.nix args';
}
