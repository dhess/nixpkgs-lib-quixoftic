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

  ## Aggregates are handy for defining jobs (especially for subsets of
  ## platforms), but they don't provide very useful information in
  ## Hydra, especially when they die. We use aggregates here to define
  ## set of jobs, and then splat them into the output attrset so that
  ## they're more visible in Hydra.

  enumerateConstituents = aggregate: lib.listToAttrs (
    map (d:
           let
             name = (builtins.parseDrvName d.name).name;
             system = d.system;
           in
             { name = name + "." + system;
               value = d;
             }
         )
        aggregate.constituents
  );

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

  }
  // (mapTestOn (packagePlatforms pkgs));

in
{
  inherit (jobs) cleanSources;
  inherit (jobs) cleanPackages;
}
// enumerateConstituents jobs.cleanSources
// enumerateConstituents jobs.cleanPackages
