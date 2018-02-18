# to run these tests:
# nix-instantiate --eval --strict ipaddr.nix
# if the resulting list is empty, all tests passed

with import <nixpkgs> { };

with pkgs.lib;
with pkgs.lib.ipaddr;

let

  allTrue = all id;
  anyTrue = any id;

in
runTests rec {

  ## IPv4.

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


  ## IPv6.

  goodAddrs = [
    "::1"
    "::"
    "::1:2:3"
    "1::2:3"
    "1:2::3:4"
    "fe80::"
    "0:0:0:0:0:0:0:0"
    "0:0:0:0:0:0:0:1"
    "0123:4567:89ab:cdef:0123:4567:89ab:cdef"
    "2001:db8:0:0:0:0:0:a"
    "2001:db8::a"
    "2001:db8:0:0:0:0:3:a"
    "2001:db8::3:a"
    "2001:db8:0:1:0:0:0:a"
    "2001:db8:0:1::a"
    "2001:db8:0:1:0:0:1:a"
    "2001:db8:0:1::1:a"
    "1:2:3:4:5:6:7::"
    "1:2:3:4:5:6::"
    "1:2:3:4:5::"
    "1:2:3:4::"
    "1:2:3::"
    "1:2::"
    "1::"

    # Dot-decimal notation for IPv4-mapped IPv6 addresses.
    "1:2:3:4:5:6:255.255.255.255"
    "1:2:3:4:5:6:0.0.0.0"
    "1:2:3:4:5::255.255.255.255"
    "1:2:3:4:5::0.0.0.0"
    "1:2:3:4::255.255.255.255"
    "1:2:3:4::0.0.0.0"
    "1:2:3::255.255.255.255"
    "1:2:3::0.0.0.0"
    "1:2::255.255.255.255"
    "1:2::0.0.0.0"
    "1::255.255.255.255"
    "1::0.0.0.0"
    "::ffff:192.168.1.1"
  ];

  test-parseV6-good = {
    expr = flatten (map parseV6 goodAddrs);
    expected = goodAddrs;
  };

  test-parseV6-good-upper-case = {
    expr = flatten (map (x: parseV6 (toUpper x)) goodAddrs);
    expected = map toUpper goodAddrs;
  };

  test-parseV6-cidr-0 = rec {
    addrs = map (x: x + "/0") goodAddrs;
    expr = flatten (map parseV6 addrs);
    expected = addrs;
  };

  test-parseV6-cidr-128 = rec {
    addrs = map (x: x + "/128") goodAddrs;
    expr = flatten (map parseV6 addrs);
    expected = addrs;
  };

  # Note: see docs for `parseV6`, but technically only the non-global
  # scope addresses should parse with a scope ID. However, the current
  # implementation does not enforce this.
  
  test-parseV6-scope-id-1 = rec {
    addrs = map (x: x + "%eth0") goodAddrs;
    expr = flatten (map parseV6 addrs);
    expected = addrs;
  };

  test-parseV6-scope-id-2 = rec {
    addrs = map (x: x + "%wg0") goodAddrs;
    expr = flatten (map parseV6 addrs);
    expected = addrs;
  };

  test-parseV6-scope-id-3 = rec {
    addrs = map (x: x + "%0") goodAddrs;
    expr = flatten (map parseV6 addrs);
    expected = addrs;
  };

  test-parseV6-scope-id-plus-cidr = rec {
    addrs = map (x: x + "%eth0/64") goodAddrs;
    expr = flatten (map parseV6 addrs);
    expected = addrs;
  };

  test-parseV6-scope-id-plus-cidr-2 = rec {
    addrs = map (x: x + "%wg0/56") goodAddrs;
    expr = flatten (map parseV6 addrs);
    expected = addrs;
  };

  test-parseV6-scope-id-plus-cidr-3 = rec {
    addrs = map (x: x + "%0/32") goodAddrs;
    expr = flatten (map parseV6 addrs);
    expected = addrs;
  };

  test-parseV6-bad-cidr-1 = rec {
    addrs = map (x: x + "/129") goodAddrs;
    expr = flatten (map parseV6 addrs);
    expected = [];
  };

  test-parseV6-bad-cidr-2 = rec {
    addrs = map (x: x + "/a") goodAddrs;
    expr = flatten (map parseV6 addrs);
    expected = [];
  };

  test-parseV6-bad-cidr-3 = rec {
    addrs = map (x: x + "/2a") goodAddrs;
    expr = flatten (map parseV6 addrs);
    expected = [];
  };

  badAddrs = [
      ""
      "1:2:3:4:5:6:7"
      "1:2::3:4:5:6:7::8"
      "1:2:3:4:5:6:7:8:9"
      "1:2::3:4:5:6:7::8:9"

      # Dot-decimal notation for IPv4-mapped IPv6 addresses.
      "1:2:3:4:5:6:7:255.255.255.255"
      "1:2:3:4:5:6:7:0.0.0.0"
      "1:2:3:4:5::256.255.255.255"
      "1:2:3:4:5::255.256.255.255"
      "1:2:3:4:5::255.255.256.255"
      "1:2:3:4:5::255.255.255.256"
      ":::ffff:192.168.1.1"
      ":ffff:192.168.1.1"

      "1:2:3:4:5:6:1.2.3"
      "1:2:3:4:5:6:0.0.0"
      "1:2:3:4:5::1.2.3"
      "1:2:3:4:5::0.0.0"
      "1:2:3:4::1.2.3"
      "1:2:3:4::0.0.0"
      "1:2:3::1.2.3"
      "1:2:3::0.0.0"
      "1:2::1.2.3"
      "1:2::0.0.0"
      "1::1.2.3"
      "1::0.0.0"

      "1:2:3:4:5:6:a.1.2.3"
      "1:2:3:4:5:6:a.0.0.0"
      "1:2:3:4:5:6:255.a.255.255"
      "1:2:3:4:5:6:0.a.0.0"
      "1:2:3:4:5:6:255.255.a.255"
      "1:2:3:4:5:6:0.0.a.0"
      "1:2:3:4:5:6:255.255.255.a"
      "1:2:3:4:5:6:0.0.0.a"
      "1:2:3:4:5:::a.255.255.255"
      "1:2:3:4:5:::a.0.0.0"
      "1:2:3:4:5:::255.a.255.255"
      "1:2:3:4:5:::0.a.0.0"
      "1:2:3:4:5:::255.255.a.255"
      "1:2:3:4:5:::0.0.a.0"
      "1:2:3:4:5:::255.255.255.a"
      "1:2:3:4:5:::0.0.0.a"

      # XXX dhess - these pass. Should they?
      # "1:2:3:4:5:6:255.255.255"
      # "1:2:3:4:5::255.255.255"
      # "1:2:3:4::255.255.255"
      # "1:2:3::255.255.255"
      # "1:2::255.255.255"
      # "1::255.255.255"

      "a"
      "abcd"
      ":::1"
      "::::1"
      "a:::1"
      "a::::1"
      "1:2:::3"
      "1:2::::3"
      "12345678::1"
      "1:2:3:4:"
      "1:2:3:4:5:6:7:8:"
      "1:2:3:4::1:"
      "1::2::3:4"
      "1::2::3::4::5::6::7::8"
      "1: 2::3"
      "12345::1"
      "::12345"
      "habc::1"
      "1234::/"
      "1234::1/"
      "::/"
      "::1/"
      "1234::1/"
      "1234::%"
      "1234::1%"
      "1234::1%eth0/"
      "1234::1/%eth0"
      "1234::/%eth0"
      "1234::/64%eth0"
      "1234::1/64%eth0"
      "1234::1%/eth0"
      "1234::%/eth0"
  ];

  test-parseV6-bad = {
    expr = flatten (map parseV6 badAddrs);
    expected = [];
  };

  test-isV6 = {
    expr = allTrue (flatten (map isV6 goodAddrs));
    expected = true;
  };

  test-isV6-good-upper-case = {
    expr = allTrue (flatten (map (x: isV6 (toUpper x)) goodAddrs));
    expected = true;
  };

  test-isV6-cidr-0 = rec {
    addrs = map (x: x + "/0") goodAddrs;
    expr = allTrue (flatten (map isV6 addrs));
    expected = true;
  };

  test-isV6-cidr-128 = rec {
    addrs = map (x: x + "/128") goodAddrs;
    expr = allTrue (flatten (map isV6 addrs));
    expected = true;
  };

  test-isV6-scope-id-1 = rec {
    addrs = map (x: x + "%eth0") goodAddrs;
    expr = allTrue (flatten (map isV6 addrs));
    expected = true;
  };

  test-isV6-scope-id-2 = rec {
    addrs = map (x: x + "%wg0") goodAddrs;
    expr = allTrue (flatten (map isV6 addrs));
    expected = true;
  };

  test-isV6-scope-id-3 = rec {
    addrs = map (x: x + "%0") goodAddrs;
    expr = allTrue (flatten (map isV6 addrs));
    expected = true;
  };

  test-isV6-scope-id-plus-cidr = rec {
    addrs = map (x: x + "%eth0/64") goodAddrs;
    expr = allTrue (flatten (map isV6 addrs));
    expected = true;
  };

  test-isV6-scope-id-plus-cidr-2 = rec {
    addrs = map (x: x + "%wg0/56") goodAddrs;
    expr = allTrue (flatten (map isV6 addrs));
    expected = true;
  };

  test-isV6-scope-id-plus-cidr-3 = rec {
    addrs = map (x: x + "%0/32") goodAddrs;
    expr = allTrue (flatten (map isV6 addrs));
    expected = true;
  };

  test-isV6-bad-cidr-1 = rec {
    addrs = map (x: x + "/129") goodAddrs;
    expr = anyTrue (flatten (map isV6 addrs));
    expected = false;
  };

  test-isV6-bad-cidr-2 = rec {
    addrs = map (x: x + "/a") goodAddrs;
    expr = anyTrue (flatten (map isV6 addrs));
    expected = false;
  };

  test-isV6-bad-cidr-3 = rec {
    addrs = map (x: x + "/2a") goodAddrs;
    expr = anyTrue (flatten (map isV6 addrs));
    expected = false;
  };

  test-isV6-bad = {
    expr = anyTrue (flatten (map isV6 badAddrs));
    expected = false;
  };

  test-isV6Cidr = {
    expr = anyTrue (flatten (map isV6Cidr goodAddrs));
    expected = false;
  };

  test-isV6Cidr-good-upper-case = {
    expr = anyTrue (flatten (map (x: isV6Cidr (toUpper x)) goodAddrs));
    expected = false;
  };

  test-isV6Cidr-cidr-0 = rec {
    addrs = map (x: x + "/0") goodAddrs;
    expr = allTrue (flatten (map isV6Cidr addrs));
    expected = true;
  };

  test-isV6Cidr-cidr-128 = rec {
    addrs = map (x: x + "/128") goodAddrs;
    expr = allTrue (flatten (map isV6Cidr addrs));
    expected = true;
  };

  test-isV6Cidr-scope-id-1 = rec {
    addrs = map (x: x + "%eth0") goodAddrs;
    expr = anyTrue (flatten (map isV6Cidr addrs));
    expected = false;
  };

  test-isV6Cidr-scope-id-2 = rec {
    addrs = map (x: x + "%wg0") goodAddrs;
    expr = anyTrue (flatten (map isV6Cidr addrs));
    expected = false;
  };

  test-isV6Cidr-scope-id-3 = rec {
    addrs = map (x: x + "%0") goodAddrs;
    expr = anyTrue (flatten (map isV6Cidr addrs));
    expected = false;
  };

  test-isV6Cidr-scope-id-plus-cidr = rec {
    addrs = map (x: x + "%eth0/64") goodAddrs;
    expr = allTrue (flatten (map isV6Cidr addrs));
    expected = true;
  };

  test-isV6Cidr-scope-id-plus-cidr-2 = rec {
    addrs = map (x: x + "%wg0/56") goodAddrs;
    expr = allTrue (flatten (map isV6Cidr addrs));
    expected = true;
  };

  test-isV6Cidr-scope-id-plus-cidr-3 = rec {
    addrs = map (x: x + "%0/32") goodAddrs;
    expr = allTrue (flatten (map isV6Cidr addrs));
    expected = true;
  };

  test-isV6Cidr-bad-cidr-1 = rec {
    addrs = map (x: x + "/129") goodAddrs;
    expr = anyTrue (flatten (map isV6Cidr addrs));
    expected = false;
  };

  test-isV6Cidr-bad-cidr-2 = rec {
    addrs = map (x: x + "/a") goodAddrs;
    expr = anyTrue (flatten (map isV6Cidr addrs));
    expected = false;
  };

  test-isV6Cidr-bad-cidr-3 = rec {
    addrs = map (x: x + "/2a") goodAddrs;
    expr = anyTrue (flatten (map isV6Cidr addrs));
    expected = false;
  };

  test-isV6Cidr-bad = {
    expr = anyTrue (flatten (map isV6Cidr badAddrs));
    expected = false;
  };

  test-isV6NoCidr = {
    expr = allTrue (flatten (map isV6NoCidr goodAddrs));
    expected = true;
  };

  test-isV6NoCidr-good-upper-case = {
    expr = allTrue (flatten (map (x: isV6NoCidr (toUpper x)) goodAddrs));
    expected = true;
  };

  test-isV6NoCidr-cidr-0 = rec {
    addrs = map (x: x + "/0") goodAddrs;
    expr = anyTrue (flatten (map isV6NoCidr addrs));
    expected = false;
  };

  test-isV6NoCidr-cidr-128 = rec {
    addrs = map (x: x + "/128") goodAddrs;
    expr = anyTrue (flatten (map isV6NoCidr addrs));
    expected = false;
  };

  test-isV6NoCidr-scope-id-1 = rec {
    addrs = map (x: x + "%eth0") goodAddrs;
    expr = allTrue (flatten (map isV6NoCidr addrs));
    expected = true;
  };

  test-isV6NoCidr-scope-id-2 = rec {
    addrs = map (x: x + "%wg0") goodAddrs;
    expr = allTrue (flatten (map isV6NoCidr addrs));
    expected = true;
  };

  test-isV6NoCidr-scope-id-3 = rec {
    addrs = map (x: x + "%0") goodAddrs;
    expr = allTrue (flatten (map isV6NoCidr addrs));
    expected = true;
  };

  test-isV6NoCidr-scope-id-plus-cidr = rec {
    addrs = map (x: x + "%eth0/64") goodAddrs;
    expr = anyTrue (flatten (map isV6NoCidr addrs));
    expected = false;
  };

  test-isV6NoCidr-scope-id-plus-cidr-2 = rec {
    addrs = map (x: x + "%wg0/56") goodAddrs;
    expr = anyTrue (flatten (map isV6NoCidr addrs));
    expected = false;
  };

  test-isV6NoCidr-scope-id-plus-cidr-3 = rec {
    addrs = map (x: x + "%0/32") goodAddrs;
    expr = anyTrue (flatten (map isV6NoCidr addrs));
    expected = false;
  };

  test-isV6NoCidr-bad-cidr-1 = rec {
    addrs = map (x: x + "/129") goodAddrs;
    expr = anyTrue (flatten (map isV6NoCidr addrs));
    expected = false;
  };

  test-isV6NoCidr-bad-cidr-2 = rec {
    addrs = map (x: x + "/a") goodAddrs;
    expr = anyTrue (flatten (map isV6NoCidr addrs));
    expected = false;
  };

  test-isV6NoCidr-bad-cidr-3 = rec {
    addrs = map (x: x + "/2a") goodAddrs;
    expr = anyTrue (flatten (map isV6NoCidr addrs));
    expected = false;
  };

  test-isV6NoCidr-bad = {
    expr = anyTrue (flatten (map isV6NoCidr badAddrs));
    expected = false;
  };

  # Note -- it is an evaluation error to call v6Addr or v6CidrSuffix
  # on an invalid IPv6 address.
  
  test-v6CidrSuffix-1 = {
    expr = v6CidrSuffix (parseV6 "2001::1/128");
    expected = [128];
  };

  test-v6CidrSuffix-2 = {
    expr = v6CidrSuffix (parseV6 "::ffff:1/32");
    expected = [32];
  };

  test-v6CidrSuffix-3 = {
    expr = v6CidrSuffix (parseV6 "1234::1/64");
    expected = [64];
  };

  test-v6CidrSuffix-4 = {
    expr = v6CidrSuffix (parseV6 "1234::1%eth0/64");
    expected = [64];
  };

  test-v6CidrSuffix-5 = {
    expr = v6CidrSuffix (parseV6 "1234::1");
    expected = [];
  };

  test-v6CidrSuffix-6 = {
    expr = v6CidrSuffix (parseV6 "::1");
    expected = [];
  };

  test-v6CidrSuffix-7 = {
    expr = v6CidrSuffix (parseV6 "::");
    expected = [];
  };

  test-v6Addr-1 = {
    expr = v6Addr (parseV6 "2001::1/128");
    expected = "2001::1";
  };

  test-v6Addr-2 = {
    expr = v6Addr (parseV6 "::ffff:1/32");
    expected = "::ffff:1";
  };

  test-v6Addr-3 = {
    expr = v6Addr (parseV6 "1234::1/64");
    expected = "1234::1";
  };

  test-v6Addr-4 = {
    expr = v6Addr (parseV6 "1234::1%eth0/64");
    expected = "1234::1%eth0";
  };

  test-v6Addr-5 = {
    expr = v6Addr (parseV6 "1234::1");
    expected = "1234::1";
  };

  test-v6Addr-6 = {
    expr = v6Addr (parseV6 "::1");
    expected = "::1";
  };

  test-v6Addr-7 = {
    expr = v6Addr (parseV6 "::");
    expected = "::";
  };

  test-unparseV6-good = {
    expr = map unparseV6 (map parseV6 goodAddrs);
    expected = goodAddrs;
  };

  test-unparseV6-good-upper-case = {
    expr = map unparseV6 (map (x: parseV6 (toUpper x)) goodAddrs);
    expected = map toUpper goodAddrs;
  };

  test-unparseV6-cidr-0 = rec {
    addrs = map (x: x + "/0") goodAddrs;
    expr = map unparseV6 (map parseV6 addrs);
    expected = addrs;
  };

  test-unparseV6-cidr-128 = rec {
    addrs = map (x: x + "/128") goodAddrs;
    expr = map unparseV6 (map parseV6 addrs);
    expected = addrs;
  };

  test-unparseV6-scope-id-1 = rec {
    addrs = map (x: x + "%eth0") goodAddrs;
    expr = map unparseV6 (map parseV6 addrs);
    expected = addrs;
  };

  test-unparseV6-scope-id-2 = rec {
    addrs = map (x: x + "%wg0") goodAddrs;
    expr = map unparseV6 (map parseV6 addrs);
    expected = addrs;
  };

  test-unparseV6-scope-id-3 = rec {
    addrs = map (x: x + "%0") goodAddrs;
    expr = map unparseV6 (map parseV6 addrs);
    expected = addrs;
  };

  test-unparseV6-scope-id-plus-cidr = rec {
    addrs = map (x: x + "%eth0/64") goodAddrs;
    expr = map unparseV6 (map parseV6 addrs);
    expected = addrs;
  };

  test-unparseV6-scope-id-plus-cidr-2 = rec {
    addrs = map (x: x + "%wg0/56") goodAddrs;
    expr = map unparseV6 (map parseV6 addrs);
    expected = addrs;
  };

  test-unparseV6-scope-id-plus-cidr-3 = rec {
    addrs = map (x: x + "%0/32") goodAddrs;
    expr = map unparseV6 (map parseV6 addrs);
    expected = addrs;
  };

}
