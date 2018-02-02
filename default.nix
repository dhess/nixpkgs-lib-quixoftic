self: super:

with super.lib;

(foldl' (flip extends) (_: super) [

  (import ./overlays/lib.nix)
  (import ./overlays/haskell-lib.nix)

]) self
