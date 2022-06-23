{
  stdenv,
  lib,
  vast-sources,
}:
stdenv.mkDerivation {
  inherit (vast-sources.vast-bin) src pname version;

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = "tar xvzf $src";

  installPhase = ''
    runHook preInstall
    mkdir -p $out

    mv {bin,share} $out

    runHook postInstall
  '';
  meta = {
    mainProgram = "vast";
  };
}
