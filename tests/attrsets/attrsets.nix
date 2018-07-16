# to run these tests:
# nix-instantiate --eval --strict attrsets.nix
# if the resulting list is empty, all tests passed

with import <nixpkgs> { };

with pkgs.lib;
with pkgs.lib.attrsets;

let

  allTrue = all id;
  anyTrue = any id;

in
runTests rec {

  test-allAttrs-true = rec {
    example = {
      foo = { name = "bob"; };
      bar = { name = "bob"; };
    };
    expr = allAttrs (v: v.name == "bob") example;
    expected = true;
  };

  test-allAttrs-trivially-true = rec {
    example = {
    };
    expr = allAttrs (v: v.name == "bob") example;
    expected = true;
  };
  
  test-allAttrs-false = rec {
    example = {
      foo = { name = "bob"; };
      bar = { name = "steve"; };
    };
    expr = allAttrs (v: v.name == "bob") example;
    expected = false;
  };


}
