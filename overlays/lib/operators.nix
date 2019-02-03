self: super:

let

  exclusiveOr = x: y: (x && !y) || (!x && y);

in
{
  lib = (super.lib or {}) // {
    inherit exclusiveOr;
  };
}
