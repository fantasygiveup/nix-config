{ stdenv, buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "fdir";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "fantasygiveup";
    repo = pname;
    rev = "main";
    sha256 = "ZKjI3UEETcYlFhbT2VmkDp5H6OdVNaAcz7utX40F5uM=";
  };

  vendorHash = null;
  doCheck = false;

  meta = with lib; {
    description = "Stupid directory finder";
    homepage = "https://github.com/fantasygiveup/${pname}";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
