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
      meta.description = "nixpkgs-lib-quixoftic cleanSources tests";
      constituents = with jobs; [
        cleanSourceNix.x86_64-linux
      ];
    };

  }
  // (mapTestOn (packagePlatforms pkgs));

in
{
  inherit (jobs) cleanSources;
}
// enumerateConstituents jobs.cleanSources
