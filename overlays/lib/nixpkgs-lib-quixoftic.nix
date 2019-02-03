self: super:

let
  # Provide access to the whole package, if needed.
  path = ../../.;

in
{
  lib = (super.lib or {}) // {
    nixpkgs-lib-quixoftic = (super.lib.nixpkgs-lib-quixoftic or {}) // {
      inherit path;
    };
  };
}
