{
  inputs,
  cell,
}: let
  inherit (inputs) std nixpkgs;
in {
  /*
  docker run --user vast -it --rm -p 42000:42000 \
  -v $(pwd)/test ghcr.io/gtrunsec/vast:latest start

  # https://www.redhat.com/sysadmin/debug-rootless-podman-mounted-volumes

  podman run -it --rm --userns=keep-id --group-add keep-groups --user vast \
  -p 42000:42000 -v $(pwd)/test:/var/lib/vast ghcr.io/gtrunsec/vast:latest start
  */
  latest = cell.lib.mkOCI cell.packages.vast-latest "latest";
}
