self: super:

let

  inherit (super) callPackage;

in
{
  cleanSourceNix = callPackage ./cleanSourceNix {};
}
