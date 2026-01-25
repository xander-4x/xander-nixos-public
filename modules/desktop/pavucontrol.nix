{pkgs, ...}: let
  deps = with pkgs; [
    pavucontrol
    gtkmm4
    glibmm
    libsigcxx
    libcanberra
    json-glib
    libpulseaudio
  ];
in {
  environment.systemPackages = [
    (pkgs.stdenv.mkDerivation {
      pname = "wrapped-pavucontrol";
      version = pkgs.pavucontrol.version;

      nativeBuildInputs = [pkgs.makeWrapper];
      buildInputs = deps;

      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        makeWrapper ${pkgs.pavucontrol}/bin/.pavucontrol-wrapped $out/bin/pavucontrol \
          --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath deps}
      '';
    })
  ];
}
