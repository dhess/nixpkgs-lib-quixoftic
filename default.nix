self: super:

with super.lib;

(foldl' (flip extends) (_: super) [

  (import ./overlays/lib.nix)

]) self
