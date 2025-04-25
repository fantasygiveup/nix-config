{ lib, stdenv, pkgs, }:
stdenv.mkDerivation {
  pname = "i3-notification-status";
  version = "1.0.0";
  # Avoid the "> variable $src or $srcs should point to the source" error.
  dontUnpack = true;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mkdir -p "$out/opt/i3-notification-status"
    substituteAll "${
      ./i3-notification-status.sh
    }" "$out/bin/i3-notification-status"
    chmod a+x "$out/bin"/*
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --prefix PATH : "${
          lib.makeBinPath [ pkgs.bash pkgs.xorg.xprop pkgs.i3 pkgs.dunst ]
        }"
    done

    runHook postInstall
  '';

  meta = {
    description = "Pretty-print i3 notification status";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    homepage = "https://github.com/fantasygiveup/nix-config";
  };
}
