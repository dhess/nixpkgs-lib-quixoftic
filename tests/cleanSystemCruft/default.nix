## checkPhase will fail unless you cleanSourceSystemCruft.

{ stdenv
, pkgs
, src ? ../test-dir
}:

let

  version = "1";
  testLib = import ../lib.nix;

in

stdenv.mkDerivation rec {
  inherit src;

  name = "nlq-cleanSystemCruft-test-${version}";

  doCheck = true;
  checkPhase = ''
    ${testLib.test-no-file "." ".DS_Store"}
  '';

  installPhase = ''
    mkdir $out
    cp -rp . $out
  '';
}
