## Convenience functions for tests, esp. for Hydras.

self: super:

let
  # Aggregates are handy for defining jobs (especially for subsets of
  # platforms), but they don't provide very useful information in
  # Hydra, especially when they die. We use aggregates here to define
  # set of jobs, and then splat them into the output attrset so that
  # they're more visible in Hydra.
  enumerateConstituents = aggregate: super.lib.listToAttrs (
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

in
{
  lib = (super.lib or {}) // {
    testing = (super.lib.testing or {}) // {
      inherit enumerateConstituents;
    };
  };
}
