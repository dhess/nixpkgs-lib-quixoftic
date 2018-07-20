## Things that I do all the time with attrsets, but aren't included in
## Nix or nixpkgs, for whatever reason.

{ lib
, ...
}:

let

in rec
{

  ## Given an attrset, return true if `pred` is true for each value in
  ## the set, else false. Here `pred` is a predicate function of one
  ## argument (the value of each attribute in the set).

  allAttrs = pred: attrs:
    lib.all pred (lib.mapAttrsToList (_: value: value) attrs);

  ## Given an attrset, return true if `pred` is true for any value in
  ## the set, else false. Here `pred` is a predicate function of one
  ## argument (the value of each attribute in the set).

  anyAttrs = pred: attrs:
    lib.any pred (lib.mapAttrsToList (_: value: value) attrs);

  ## Given an attrset, return true if `pred` is true for no value in
  ## the set, else false. Here `pred` is a predicate function of one
  ## argument (the value of each attribute in the set).

  noAttrs = pred: attrs: !(anyAttrs pred attrs);

}
