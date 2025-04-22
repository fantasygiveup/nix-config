{ lib, stdenv, pkgs, }:
stdenv.mkDerivation {
  pname = "x11-title";
  version = "1.0.0";
  # Avoid the "> variable $src or $srcs should point to the source" error.
  dontUnpack = true;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mkdir -p "$out/opt/x11-title"
    substituteAll "${./x11-title.sh}" "$out/bin/x11-title"
    chmod a+x "$out/bin"/*
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --prefix PATH : "${
          lib.makeBinPath [ pkgs.coreutils pkgs.bash pkgs.xorg.xprop ]
        }"
    done

    runHook postInstall
  '';

  meta = {
    description =
      "Print the focused window's title at regular intervals for X11";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    homepage = "https://github.com/fantasygiveup/nix-config";
  };
}
