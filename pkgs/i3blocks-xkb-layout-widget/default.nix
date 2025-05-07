{ lib, stdenv, pkgs, }:
stdenv.mkDerivation {
  pname = "i3blocks-xkb-layout-widget";
  version = "1.0.0";
  # Avoid the "> variable $src or $srcs should point to the source" error.
  dontUnpack = true;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mkdir -p "$out/opt/i3blocks-xkb-layout-widget"
    substituteAll "${
      ./i3blocks-xkb-layout-widget.sh
    }" "$out/bin/i3blocks-xkb-layout-widget"
    chmod a+x "$out/bin"/*
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --prefix PATH : "${
          lib.makeBinPath [ pkgs.coreutils pkgs.bash pkgs.xkb-switch-i3 ]
        }"
    done

    runHook postInstall
  '';

  meta = {
    description = "Print keyboard layout with emoji country flag";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    homepage = "https://github.com/fantasygiveup/nix-config";
  };
}
