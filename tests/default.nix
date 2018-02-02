self: super:

let

  inherit (super) callPackage;
  inherit (self) lib;

in
{
  ## cleanSourceX tests.

  nlqCleanSourceNix = callPackage ./cleanNix { src = lib.cleanSourceNix ./test-dir; };
  nlqCleanSourceHaskell = callPackage ./cleanHaskell { src = lib.cleanSourceHaskell ./test-dir; };
  nlqCleanSourceSystemCruft = callPackage ./cleanSystemCruft { src = lib.cleanSourceSystemCruft ./test-dir; };
  nlqCleanSourceEditors = callPackage ./cleanEditors { src = lib.cleanSourceEditors ./test-dir; };
  nlqCleanSourceMaintainer = callPackage ./cleanMaintainer { src = lib.cleanSourceMaintainer ./test-dir; };
  nlqCleanSourceAllExtraneous = callPackage ./cleanAllExtraneous { src = lib.cleanSourceAllExtraneous ./test-dir; };

}
