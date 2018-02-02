{ stdenv
, pkgs
}:

let

  version = "1";

in
stdenv.mkDerivation rec {
  name = "cleanSourceNix-test-${version}";

  src = pkgs.lib.cleanSourceNix ../test-dir;

  doCheck = true;
  checkPhase = ''
    echo -n "Checking for nix directory... "
    [[ "$(./bin/dir-exists.sh . nix)" == "yes" ]] || (echo "nix directory does not exist!" && exit 1)
    echo "pass"

    echo -n "Checking for no *.nix files... "
    [[ "$(./bin/file-exists.sh . "*.nix")" == "no" ]] || (echo "nix files exist!" && exit 1)
    echo "pass"
  '';

  installPhase = ''
    mkdir $out
    cp -rp . $out
  '';
}
