self: super:

let

  dhess-pers = "Drew Hess <src@drewhess.com>";

in
{
  lib = (super.lib or {}) // {
    maintainers = (super.lib.maintainers or {}) // {
      inherit dhess-pers;
    };
  };
}
