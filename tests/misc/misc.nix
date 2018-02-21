# to run these tests:
# nix-instantiate --eval --strict misc.nix
# if the resulting list is empty, all tests passed

with import <nixpkgs> { };

with pkgs.lib;

runTests {

  test-exclusiveOr-1 = rec {
    expr = exclusiveOr false false;
    expected = false;
  };

  test-exclusiveOr-2 = rec {
    expr = exclusiveOr true true;
    expected = false;
  };

  test-exclusiveOr-3 = rec {
    expr = exclusiveOr true false;
    expected = true;
  };

  test-exclusiveOr-4 = rec {
    expr = exclusiveOr false true;
    expected = true;
  };

}
