{ lib, stdenv, pkgs }:
stdenv.mkDerivation {
  pname = "erun";
  version = "1.0.0";
  # Avoid the "> variable $src or $srcs should point to the source" error.
  dontUnpack = true;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mkdir -p "$out/opt/erun"
    substituteAll "${./erun.sh}" "$out/bin/erun"
    cp -r "${./scripts}" "$out/opt/erun/scripts"
    chmod a+x "$out/bin"/*
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --prefix PATH : "${lib.makeBinPath [ pkgs.elixir ]}"
    done

    runHook postInstall
  '';

  meta = {
    description = "Executes elixir exs files";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    homepage = "https://github.com/fantasygiveup/nix-config";
  };
}
