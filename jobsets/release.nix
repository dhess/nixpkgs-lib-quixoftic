let

  fixedNixPkgs = (import ../lib.nix).fetchNixPkgs;

in

{ supportedSystems ? [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ]
, scrubJobs ? true
, nixpkgsArgs ? {
    config = {allowUnfree = false; inHydra = true; };
    overlays = [
      (import ../.)
      (import ../tests)
    ];
  }
}:

with import (fixedNixPkgs + "/pkgs/top-level/release-lib.nix") {
  inherit supportedSystems scrubJobs nixpkgsArgs;
};

(mapTestOn (rec {
  nlqCleanSourceNix = all;
  nlqCleanSourceHaskell = all;
  nlqCleanSourceSystemCruft = all;
  nlqCleanSourceEditors = all;
  nlqCleanSourceMaintainer = all;
  nlqCleanSourceAllExtraneous = all;
  nlqCleanPackageNix = all;
  nlqCleanPackageHaskell = all;
  nlqCleanPackageSystemCruft = all;
  nlqCleanPackageEditors = all;
  nlqCleanPackageMaintainer = all;
  nlqCleanPackageAllExtraneous = all;
  nlqAttrSets = all;
  nlqIPAddr = all;
  nlqMisc = all;
  nlqFfdhe = all;
  nlqTypes = all;
}))
