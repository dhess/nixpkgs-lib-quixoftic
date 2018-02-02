self: super:

{
  haskell = (super.haskell or {}) // {

    lib = (super.haskell.lib or {}) // {

      ## Sometimes you don't want any haddocks to be generated for an
      ## entire package set, rather than just a package here or there.
      noHaddocks = hp: (hp.extend (self: super: (
        {
          mkDerivation = args: super.mkDerivation (args // {
            doHaddock = false;
          });
        }
      )));
    };
  };
}
