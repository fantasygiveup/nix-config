{ lib, stdenv, pkgs, }:
stdenv.mkDerivation {
  pname = "dunstctl-count-history";
  version = "1.0.0";
  # Avoid the "> variable $src or $srcs should point to the source" error.
  dontUnpack = true;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    substituteAll "${
      ./dunstctl-count-history.sh
    }" "$out/bin/dunstctl-count-history"
    chmod a+x "$out/bin"/*
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --prefix PATH : "${lib.makeBinPath [ pkgs.dunst ]}"
    done

    runHook postInstall
  '';

  meta = {
    description =
      "Wrapper for 'dunstctl count history' with decimal precision output";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    homepage = "https://github.com/fantasygiveup/nix-config";
  };
}
