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

let

  all = pkg: map (system: pkg.${system}) supportedSystems;

  jobs = {

    cleanSources = pkgs.releaseTools.aggregate {
      name = "nixpkgs-lib-quixoftic-cleanSources";
      meta.description = "nixpkgs-lib-quixoftic cleanSource tests";
      constituents = with jobs; [
        nlqCleanSourceNix.x86_64-linux
        (all nlqCleanSourceHaskell)
        (all nlqCleanSourceSystemCruft)
        (all nlqCleanSourceEditors)
        (all nlqCleanSourceMaintainer)
        (all nlqCleanSourceAllExtraneous)
      ];
    };


    ## Note that these jobs should evaluate to the same values as their
    ## namesakes in cleanSources.

    cleanPackages = pkgs.releaseTools.aggregate {
      name = "nixpkgs-lib-quixoftic-cleanPackages";
      meta.description = "nixpkgs-lib-quixoftic cleanPackage tests";
      constituents = with jobs; [
        (all nlqCleanPackageNix)
        (all nlqCleanPackageHaskell)
        (all nlqCleanPackageSystemCruft)
        (all nlqCleanPackageEditors)
        (all nlqCleanPackageMaintainer)
        (all nlqCleanPackageAllExtraneous)
      ];
    };

    attrsets = pkgs.releaseTools.aggregate {
      name = "nixpkgs-lib-quixoftic-attrsets";
      meta.description = "nixpkgs-lib-quixoftic attrsets tests";
      constituents = with jobs; [
        (all nlqAttrSets)
      ];
    };

    ipaddr = pkgs.releaseTools.aggregate {
      name = "nixpkgs-lib-quixoftic-ipaddr";
      meta.description = "nixpkgs-lib-quixoftic ipaddr tests";
      constituents = with jobs; [
        (all nlqIPAddr)
      ];
    };

    misc = pkgs.releaseTools.aggregate {
      name = "nixpkgs-lib-quixoftic-misc";
      meta.description = "nixpkgs-lib-quixoftic miscellaneous tests";
      constituents = with jobs; [
        (all nlqMisc)
      ];
    };

    security = pkgs.releaseTools.aggregate {
      name = "nixpkgs-lib-quixoftic-security";
      meta.description = "nixpkgs-lib-quixoftic security tests";
      constituents = with jobs; [
        (all nlqFfdhe)
      ];
    };

    types = pkgs.releaseTools.aggregate {
      name = "nixpkgs-lib-quixoftic-types";
      meta.description = "nixpkgs-lib-quixoftic types tests";
      constituents = with jobs; [
        (all nlqTypes)
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
  inherit (jobs) attrsets;
  inherit (jobs) ipaddr;
  inherit (jobs) misc;
  inherit (jobs) security;
  inherit (jobs) types;
}
// pkgs.lib.testing.enumerateConstituents jobs.cleanSources
// pkgs.lib.testing.enumerateConstituents jobs.cleanPackages
// pkgs.lib.testing.enumerateConstituents jobs.attrsets
// pkgs.lib.testing.enumerateConstituents jobs.ipaddr
// pkgs.lib.testing.enumerateConstituents jobs.misc
// pkgs.lib.testing.enumerateConstituents jobs.security
// pkgs.lib.testing.enumerateConstituents jobs.types
