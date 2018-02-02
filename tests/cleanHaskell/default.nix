## checkPhase will fail unless you cleanSourceHaskell

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

  name = "nlq-cleanHaskell-test-${version}";

  doCheck = true;
  checkPhase = ''
    ${testLib.test-no-dir "." ".cabal-sandbox"}
    ${testLib.test-no-dir "." ".stack-work"}
    ${testLib.test-no-dir "." "dist"}
    ${testLib.test-no-dir "." "dist-newstyle"}

    ${testLib.test-no-file "." ".ghci"}
    ${testLib.test-no-file "." ".stylish-haskell.yaml"}
    ${testLib.test-no-file "." "cabal.sandbox.config"}
  '';

  installPhase = ''
    mkdir $out
    cp -rp . $out
  '';
}
