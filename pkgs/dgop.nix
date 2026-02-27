{
  lib,
  buildGoModule,
  src,
}:
buildGoModule {
  pname = "dgop";
  version = src.shortRev or "unstable";

  inherit src;

  vendorHash = "sha256-OxcSnBIDwbPbsXRHDML/Yaxcc5caoKMIDVHLFXaoSsc=";

  meta = with lib; {
    description = "System monitoring tool with CLI and REST API";
    homepage = "https://github.com/AvengeMedia/dgop";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
