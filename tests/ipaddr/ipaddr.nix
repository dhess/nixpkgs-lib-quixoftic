# to run these tests:
# nix-instantiate --eval --strict ipaddr.nix
# if the resulting list is empty, all tests passed

with import <nixpkgs> { };

with pkgs.lib;
with pkgs.lib.ipaddr;

runTests {

  test-parseV4-1 = {
    expr = parseV4 "10.0.10.1";
    expected = [ 10 0 10 1 ];
  };

  test-parseV4-2 = {
    expr = parseV4 "10.0.10.1/24";
    expected = [ 10 0 10 1 24 ];
  };

  test-parseV4-3 = {
    expr = parseV4 "10.0.10/24";
    expected = [ ];
  };

  test-parseV4-4 = {
    expr = parseV4 "256.255.255.255";
    expected = [ ];
  };

  test-parseV4-5 = {
    expr = parseV4 "10.0.10.1/33";
    expected = [ ];
  };

  test-parseV4-6 = {
    expr = parseV4 "-10.0.10.1";
    expected = [ ];
  };

  test-parseV4-7 = {
    expr = parseV4 "10.0.10.1.33";
    expected = [ ];
  };

  test-parseV4-8 = {
    expr = parseV4 "0.0.0.0/0";
    expected = [ 0 0 0 0 0 ];
  };

  test-parseV4-9 = {
    expr = parseV4 "255.255.255.255/32";
    expected = [ 255 255 255 255 32 ];
  };

  test-isV4-1 = {
    expr = isV4 "10.0.10.1";
    expected = true;
  };

  test-isV4-2 = {
    expr = isV4 "10.0.10.1/24";
    expected = true;
  };

  test-isV4-3 = {
    expr = isV4 "10.0.10/24";
    expected = false;
  };

  test-isV4-4 = {
    expr = isV4 "256.255.255.255";
    expected = false;
  };

  test-isV4-5 = {
    expr = isV4 "10.0.10.1/33";
    expected = false;
  };

  test-isV4-6 = {
    expr = isV4 "-10.0.10.1";
    expected = false;
  };

  test-isV4-7 = {
    expr = isV4 "10.0.10.1.33";
    expected = false;
  };

  test-isV4-8 = {
    expr = isV4 "0.0.0.0/0";
    expected = true;
  };

  test-isV4-9 = {
    expr = isV4 "255.255.255.255/32";
    expected = true;
  };

  test-isV4Cidr-1 = {
    expr = isV4Cidr "10.0.10.1";
    expected = false;
  };

  test-isV4Cidr-2 = {
    expr = isV4Cidr "10.0.10.1/24";
    expected = true;
  };

  test-isV4Cidr-3 = {
    expr = isV4Cidr "10.0.10/24";
    expected = false;
  };

  test-isV4Cidr-4 = {
    expr = isV4Cidr "256.255.255.255";
    expected = false;
  };

  test-isV4Cidr-5 = {
    expr = isV4Cidr "10.0.10.1/33";
    expected = false;
  };

  test-isV4Cidr-6 = {
    expr = isV4Cidr "-10.0.10.1";
    expected = false;
  };

  test-isV4Cidr-7 = {
    expr = isV4Cidr "10.0.10.1.33";
    expected = false;
  };

  test-isV4Cidr-8 = {
    expr = isV4Cidr "0.0.0.0/0";
    expected = true;
  };

  test-isV4Cidr-9 = {
    expr = isV4Cidr "255.255.255.255/32";
    expected = true;
  };

  test-isV4NoCidr-1 = {
    expr = isV4NoCidr "10.0.10.1";
    expected = true;
  };

  test-isV4NoCidr-2 = {
    expr = isV4NoCidr "10.0.10.1/24";
    expected = false;
  };

  test-isV4NoCidr-3 = {
    expr = isV4NoCidr "10.0.10/24";
    expected = false;
  };

  test-isV4NoCidr-4 = {
    expr = isV4NoCidr "256.255.255.255";
    expected = false;
  };

  test-isV4NoCidr-5 = {
    expr = isV4NoCidr "10.0.10.1/33";
    expected = false;
  };

  test-isV4NoCidr-6 = {
    expr = isV4NoCidr "-10.0.10.1";
    expected = false;
  };

  test-isV4NoCidr-7 = {
    expr = isV4NoCidr "10.0.10.1.33";
    expected = false;
  };

  test-isV4NoCidr-8 = {
    expr = isV4NoCidr "0.0.0.0/0";
    expected = false;
  };

  test-isV4NoCidr-9 = {
    expr = isV4NoCidr "255.255.255.255/32";
    expected = false;
  };

  test-v4Addr-1 = {
    expr = v4Addr (parseV4 "10.0.10.1");
    expected = [ 10 0 10 1 ];
  };

  test-v4Addr-2 = {
    expr = v4Addr (parseV4 "10.0.10.1/24");
    expected = [ 10 0 10 1 ];
  };

  test-v4CidrSuffix-1 = {
    expr = v4CidrSuffix (parseV4 "10.0.10.1");
    expected = [ ];
  };

  test-c4CidrSuffix-2 = {
    expr = v4CidrSuffix (parseV4 "10.0.10.1/24");
    expected = [ 24 ];
  };

  test-unparseV4-1 = {
    expr = unparseV4 [ 10 0 10 1 ];
    expected = "10.0.10.1";
  };

  test-unparseV4-2 = {
    expr = unparseV4 [ 10 0 10 1 24 ];
    expected = "10.0.10.1/24";
  };

  test-unparseV4-3 = {
    expr = unparseV4 [ 10 0 1000 1 ];
    expected = "";
  };

  test-unparseV4-4 = {
    expr = unparseV4 [ 10 0 10 1 33 ];
    expected = "";
  };

  test-unparseV4-5 = {
    expr = unparseV4 [ 10 0 10 ];
    expected = "";
  };

  test-unparseV4-6 = {
    expr = unparseV4 [ 10 0 10 1 24 3 ];
    expected = "";
  };

}
