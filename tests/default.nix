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


  ## cleanPackage tests.

  nlqCleanPackageNix = lib.cleanPackage lib.cleanSourceNix (callPackage ./cleanNix { src = ./test-dir;});
  nlqCleanPackageHaskell = lib.cleanPackage lib.cleanSourceHaskell (callPackage ./cleanHaskell { src = ./test-dir;});
  nlqCleanPackageSystemCruft = lib.cleanPackage lib.cleanSourceSystemCruft (callPackage ./cleanSystemCruft { src = ./test-dir;});
  nlqCleanPackageEditors = lib.cleanPackage lib.cleanSourceEditors (callPackage ./cleanEditors { src = ./test-dir;});
  nlqCleanPackageMaintainer = lib.cleanPackage lib.cleanSourceMaintainer (callPackage ./cleanMaintainer { src = ./test-dir;});
  nlqCleanPackageAllExtraneous = lib.cleanPackage lib.cleanSourceAllExtraneous (callPackage ./cleanAllExtraneous { src = ./test-dir;});

}
