{ lib, stdenv, pkgs, }:
stdenv.mkDerivation {
  pname = "mem-usage";
  version = "1.0.0";
  # Avoid the "> variable $src or $srcs should point to the source" error.
  dontUnpack = true;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mkdir -p "$out/opt/mem-usage"
    substituteAll "${./mem-usage.sh}" "$out/bin/mem-usage"
    chmod a+x "$out/bin"/*
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --prefix PATH : "${lib.makeBinPath [ pkgs.coreutils pkgs.bash ]}"
    done

    runHook postInstall
  '';

  meta = {
    description =
      "Calculate current memory usage as a percentage based on /proc/meminfo";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    homepage = "https://github.com/fantasygiveup/nix-config";
  };
}
