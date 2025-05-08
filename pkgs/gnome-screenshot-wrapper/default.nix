{ lib, stdenv, pkgs, }:
stdenv.mkDerivation {
  pname = "gnome-screenshot-wrapper";
  version = "1.0.0";
  # Avoid the "> variable $src or $srcs should point to the source" error.
  dontUnpack = true;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    substituteAll "${
      ./gnome-screenshot-wrapper.sh
    }" "$out/bin/gnome-screenshot-wrapper"
    chmod a+x "$out/bin"/*
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --prefix PATH : "${
          lib.makeBinPath [ pkgs.coreutils pkgs.bash pkgs.gnome-screenshot ]
        }"
    done

    runHook postInstall
  '';

  meta = {
    description = "Print-screen active window following filename convention";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    homepage = "https://github.com/fantasygiveup/nix-config";
  };
}
