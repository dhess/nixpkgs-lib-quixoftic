let

  fixedNixPkgs = (import ../lib.nix).fetchNixPkgs;

in

{ supportedSystems ? [ "x86_64-linux" ]
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

let

  jobs = {

    cleanSources = pkgs.releaseTools.aggregate {
      name = "nixpkgs-lib-quixoftic-cleanSources";
      meta.description = "nixpkgs-lib-quixoftic cleanSource tests";
      constituents = with jobs; [
        nlqCleanSourceNix.x86_64-linux
        nlqCleanSourceHaskell.x86_64-linux
        nlqCleanSourceSystemCruft.x86_64-linux
        nlqCleanSourceEditors.x86_64-linux
        nlqCleanSourceMaintainer.x86_64-linux
        nlqCleanSourceAllExtraneous.x86_64-linux
      ];
    };


    ## Note that these jobs should evaluate to the same values as their
    ## namesakes in cleanSources.

    cleanPackages = pkgs.releaseTools.aggregate {
      name = "nixpkgs-lib-quixoftic-cleanPackages";
      meta.description = "nixpkgs-lib-quixoftic cleanPackage tests";
      constituents = with jobs; [
        nlqCleanPackageNix.x86_64-linux
        nlqCleanPackageHaskell.x86_64-linux
        nlqCleanPackageSystemCruft.x86_64-linux
        nlqCleanPackageEditors.x86_64-linux
        nlqCleanPackageMaintainer.x86_64-linux
        nlqCleanPackageAllExtraneous.x86_64-linux
      ];
    };


    ipaddr = pkgs.releaseTools.aggregate {
      name = "nixpkgs-lib-quixoftic-ipaddr";
      meta.description = "nixpkgs-lib-quixoftic ipaddr tests";
      constituents = with jobs; [
        nlqIPAddr.x86_64-linux
      ];
    };

    security = pkgs.releaseTools.aggregate {
      name = "nixpkgs-lib-quixoftic-security";
      meta.description = "nixpkgs-lib-quixoftic security tests";
      constituents = with jobs; [
        nlqFfdhe.x86_64-linux
      ];
    };

    types = pkgs.releaseTools.aggregate {
      name = "nixpkgs-lib-quixoftic-types";
      meta.description = "nixpkgs-lib-quixoftic types tests";
      constituents = with jobs; [
        nlqTypes.x86_64-linux
      ];
    };

  }
  // (mapTestOn ((packagePlatforms pkgs) // rec {

    # This doesn't generate any actual jobs, we just want to make sure
    # it evaluates properly.
    haskell = packagePlatforms pkgs.haskell;
  }));

in
{
  inherit (jobs) cleanSources;
  inherit (jobs) cleanPackages;
  inherit (jobs) haskell;
  inherit (jobs) ipaddr;
  inherit (jobs) security;
  inherit (jobs) types;
}
// pkgs.lib.testing.enumerateConstituents jobs.cleanSources
// pkgs.lib.testing.enumerateConstituents jobs.cleanPackages
// pkgs.lib.testing.enumerateConstituents jobs.ipaddr
// pkgs.lib.testing.enumerateConstituents jobs.security
// pkgs.lib.testing.enumerateConstituents jobs.types
