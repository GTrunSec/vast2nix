{
  inputs,
  cell,
}: {
  vast = inputs.vast-overlay.nixosModules.vast;
  vast-client = ./module-client.nix;
}
