self: super:

let

  toNixFromFile = fileName:
  let
    source = builtins.readFile fileName;
  in
    super.dhallToNix source;

in
{
  lib = (super.lib or {}) // {
    dhall = (super.lib.dhall or {}) // {
      inherit toNixFromFile;
    };
  };
}
