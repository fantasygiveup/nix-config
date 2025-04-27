{ lib, stdenv, pkgs, }:
stdenv.mkDerivation {
  pname = "i3-current-window-title";
  version = "1.0.0";
  # Avoid the "> variable $src or $srcs should point to the source" error.
  dontUnpack = true;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mkdir -p "$out/opt/i3-current-window-title"
    substituteAll "${
      ./i3-current-window-title.sh
    }" "$out/bin/i3-current-window-title"
    chmod a+x "$out/bin"/*
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --prefix PATH : "${
          lib.makeBinPath [ pkgs.coreutils pkgs.bash pkgs.i3 ]
        }"
    done

    runHook postInstall
  '';

  meta = {
    description =
      "Print the focused window's title with metadata at regular intervals for i3wm";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    homepage = "https://github.com/fantasygiveup/nix-config";
  };
}
