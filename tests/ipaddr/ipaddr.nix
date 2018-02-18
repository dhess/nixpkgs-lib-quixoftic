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

  test-parseIPv4-1 = {
    expr = parseIPv4 "10.0.10.1";
    expected = [ 10 0 10 1 ];
  };

  test-parseIPv4-2 = {
    expr = parseIPv4 "10.0.10.1/24";
    expected = [ 10 0 10 1 24 ];
  };

  test-parseIPv4-3 = {
    expr = parseIPv4 "10.0.10/24";
    expected = [ ];
  };

  test-parseIPv4-4 = {
    expr = parseIPv4 "256.255.255.255";
    expected = [ ];
  };

  test-parseIPv4-5 = {
    expr = parseIPv4 "10.0.10.1/33";
    expected = [ ];
  };

  test-parseIPv4-6 = {
    expr = parseIPv4 "-10.0.10.1";
    expected = [ ];
  };

  test-parseIPv4-7 = {
    expr = parseIPv4 "10.0.10.1.33";
    expected = [ ];
  };

  test-parseIPv4-8 = {
    expr = parseIPv4 "0.0.0.0/0";
    expected = [ 0 0 0 0 0 ];
  };

  test-parseIPv4-9 = {
    expr = parseIPv4 "255.255.255.255/32";
    expected = [ 255 255 255 255 32 ];
  };

  test-isIPv4-1 = {
    expr = isIPv4 "10.0.10.1";
    expected = true;
  };

  test-isIPv4-2 = {
    expr = isIPv4 "10.0.10.1/24";
    expected = true;
  };

  test-isIPv4-3 = {
    expr = isIPv4 "10.0.10/24";
    expected = false;
  };

  test-isIPv4-4 = {
    expr = isIPv4 "256.255.255.255";
    expected = false;
  };

  test-isIPv4-5 = {
    expr = isIPv4 "10.0.10.1/33";
    expected = false;
  };

  test-isIPv4-6 = {
    expr = isIPv4 "-10.0.10.1";
    expected = false;
  };

  test-isIPv4-7 = {
    expr = isIPv4 "10.0.10.1.33";
    expected = false;
  };

  test-isIPv4-8 = {
    expr = isIPv4 "0.0.0.0/0";
    expected = true;
  };

  test-isIPv4-9 = {
    expr = isIPv4 "255.255.255.255/32";
    expected = true;
  };

  test-isIPv4CIDR-1 = {
    expr = isIPv4CIDR "10.0.10.1";
    expected = false;
  };

  test-isIPv4CIDR-2 = {
    expr = isIPv4CIDR "10.0.10.1/24";
    expected = true;
  };

  test-isIPv4CIDR-3 = {
    expr = isIPv4CIDR "10.0.10/24";
    expected = false;
  };

  test-isIPv4CIDR-4 = {
    expr = isIPv4CIDR "256.255.255.255";
    expected = false;
  };

  test-isIPv4CIDR-5 = {
    expr = isIPv4CIDR "10.0.10.1/33";
    expected = false;
  };

  test-isIPv4CIDR-6 = {
    expr = isIPv4CIDR "-10.0.10.1";
    expected = false;
  };

  test-isIPv4CIDR-7 = {
    expr = isIPv4CIDR "10.0.10.1.33";
    expected = false;
  };

  test-isIPv4CIDR-8 = {
    expr = isIPv4CIDR "0.0.0.0/0";
    expected = true;
  };

  test-isIPv4CIDR-9 = {
    expr = isIPv4CIDR "255.255.255.255/32";
    expected = true;
  };

  test-isIPv4NoCIDR-1 = {
    expr = isIPv4NoCIDR "10.0.10.1";
    expected = true;
  };

  test-isIPv4NoCIDR-2 = {
    expr = isIPv4NoCIDR "10.0.10.1/24";
    expected = false;
  };

  test-isIPv4NoCIDR-3 = {
    expr = isIPv4NoCIDR "10.0.10/24";
    expected = false;
  };

  test-isIPv4NoCIDR-4 = {
    expr = isIPv4NoCIDR "256.255.255.255";
    expected = false;
  };

  test-isIPv4NoCIDR-5 = {
    expr = isIPv4NoCIDR "10.0.10.1/33";
    expected = false;
  };

  test-isIPv4NoCIDR-6 = {
    expr = isIPv4NoCIDR "-10.0.10.1";
    expected = false;
  };

  test-isIPv4NoCIDR-7 = {
    expr = isIPv4NoCIDR "10.0.10.1.33";
    expected = false;
  };

  test-isIPv4NoCIDR-8 = {
    expr = isIPv4NoCIDR "0.0.0.0/0";
    expected = false;
  };

  test-isIPv4NoCIDR-9 = {
    expr = isIPv4NoCIDR "255.255.255.255/32";
    expected = false;
  };

  test-ipv4Addr-1 = {
    expr = ipv4Addr (parseIPv4 "10.0.10.1");
    expected = [ 10 0 10 1 ];
  };

  test-ipv4Addr-2 = {
    expr = ipv4Addr (parseIPv4 "10.0.10.1/24");
    expected = [ 10 0 10 1 ];
  };

  test-ipv4CIDRSuffix-1 = {
    expr = ipv4CIDRSuffix (parseIPv4 "10.0.10.1");
    expected = [ ];
  };

  test-c4CIDRSuffix-2 = {
    expr = ipv4CIDRSuffix (parseIPv4 "10.0.10.1/24");
    expected = [ 24 ];
  };

  test-unparseIPv4-1 = {
    expr = unparseIPv4 [ 10 0 10 1 ];
    expected = "10.0.10.1";
  };

  test-unparseIPv4-2 = {
    expr = unparseIPv4 [ 10 0 10 1 24 ];
    expected = "10.0.10.1/24";
  };

  test-unparseIPv4-3 = {
    expr = unparseIPv4 [ 10 0 1000 1 ];
    expected = "";
  };

  test-unparseIPv4-4 = {
    expr = unparseIPv4 [ 10 0 10 1 33 ];
    expected = "";
  };

  test-unparseIPv4-5 = {
    expr = unparseIPv4 [ 10 0 10 ];
    expected = "";
  };

  test-unparseIPv4-6 = {
    expr = unparseIPv4 [ 10 0 10 1 24 3 ];
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

  test-parseIPv6-good = {
    expr = flatten (map parseIPv6 goodAddrs);
    expected = goodAddrs;
  };

  test-parseIPv6-good-upper-case = {
    expr = flatten (map (x: parseIPv6 (toUpper x)) goodAddrs);
    expected = map toUpper goodAddrs;
  };

  test-parseIPv6-cidr-0 = rec {
    addrs = map (x: x + "/0") goodAddrs;
    expr = flatten (map parseIPv6 addrs);
    expected = addrs;
  };

  test-parseIPv6-cidr-128 = rec {
    addrs = map (x: x + "/128") goodAddrs;
    expr = flatten (map parseIPv6 addrs);
    expected = addrs;
  };

  # Note: see docs for `parseIPv6`, but technically only the non-global
  # scope addresses should parse with a scope ID. However, the current
  # implementation does not enforce this.
  
  test-parseIPv6-scope-id-1 = rec {
    addrs = map (x: x + "%eth0") goodAddrs;
    expr = flatten (map parseIPv6 addrs);
    expected = addrs;
  };

  test-parseIPv6-scope-id-2 = rec {
    addrs = map (x: x + "%wg0") goodAddrs;
    expr = flatten (map parseIPv6 addrs);
    expected = addrs;
  };

  test-parseIPv6-scope-id-3 = rec {
    addrs = map (x: x + "%0") goodAddrs;
    expr = flatten (map parseIPv6 addrs);
    expected = addrs;
  };

  test-parseIPv6-scope-id-plus-cidr = rec {
    addrs = map (x: x + "%eth0/64") goodAddrs;
    expr = flatten (map parseIPv6 addrs);
    expected = addrs;
  };

  test-parseIPv6-scope-id-plus-cidr-2 = rec {
    addrs = map (x: x + "%wg0/56") goodAddrs;
    expr = flatten (map parseIPv6 addrs);
    expected = addrs;
  };

  test-parseIPv6-scope-id-plus-cidr-3 = rec {
    addrs = map (x: x + "%0/32") goodAddrs;
    expr = flatten (map parseIPv6 addrs);
    expected = addrs;
  };

  test-parseIPv6-bad-cidr-1 = rec {
    addrs = map (x: x + "/129") goodAddrs;
    expr = flatten (map parseIPv6 addrs);
    expected = [];
  };

  test-parseIPv6-bad-cidr-2 = rec {
    addrs = map (x: x + "/a") goodAddrs;
    expr = flatten (map parseIPv6 addrs);
    expected = [];
  };

  test-parseIPv6-bad-cidr-3 = rec {
    addrs = map (x: x + "/2a") goodAddrs;
    expr = flatten (map parseIPv6 addrs);
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

  test-parseIPv6-bad = {
    expr = flatten (map parseIPv6 badAddrs);
    expected = [];
  };

  test-isIPv6 = {
    expr = allTrue (flatten (map isIPv6 goodAddrs));
    expected = true;
  };

  test-isIPv6-good-upper-case = {
    expr = allTrue (flatten (map (x: isIPv6 (toUpper x)) goodAddrs));
    expected = true;
  };

  test-isIPv6-cidr-0 = rec {
    addrs = map (x: x + "/0") goodAddrs;
    expr = allTrue (flatten (map isIPv6 addrs));
    expected = true;
  };

  test-isIPv6-cidr-128 = rec {
    addrs = map (x: x + "/128") goodAddrs;
    expr = allTrue (flatten (map isIPv6 addrs));
    expected = true;
  };

  test-isIPv6-scope-id-1 = rec {
    addrs = map (x: x + "%eth0") goodAddrs;
    expr = allTrue (flatten (map isIPv6 addrs));
    expected = true;
  };

  test-isIPv6-scope-id-2 = rec {
    addrs = map (x: x + "%wg0") goodAddrs;
    expr = allTrue (flatten (map isIPv6 addrs));
    expected = true;
  };

  test-isIPv6-scope-id-3 = rec {
    addrs = map (x: x + "%0") goodAddrs;
    expr = allTrue (flatten (map isIPv6 addrs));
    expected = true;
  };

  test-isIPv6-scope-id-plus-cidr = rec {
    addrs = map (x: x + "%eth0/64") goodAddrs;
    expr = allTrue (flatten (map isIPv6 addrs));
    expected = true;
  };

  test-isIPv6-scope-id-plus-cidr-2 = rec {
    addrs = map (x: x + "%wg0/56") goodAddrs;
    expr = allTrue (flatten (map isIPv6 addrs));
    expected = true;
  };

  test-isIPv6-scope-id-plus-cidr-3 = rec {
    addrs = map (x: x + "%0/32") goodAddrs;
    expr = allTrue (flatten (map isIPv6 addrs));
    expected = true;
  };

  test-isIPv6-bad-cidr-1 = rec {
    addrs = map (x: x + "/129") goodAddrs;
    expr = anyTrue (flatten (map isIPv6 addrs));
    expected = false;
  };

  test-isIPv6-bad-cidr-2 = rec {
    addrs = map (x: x + "/a") goodAddrs;
    expr = anyTrue (flatten (map isIPv6 addrs));
    expected = false;
  };

  test-isIPv6-bad-cidr-3 = rec {
    addrs = map (x: x + "/2a") goodAddrs;
    expr = anyTrue (flatten (map isIPv6 addrs));
    expected = false;
  };

  test-isIPv6-bad = {
    expr = anyTrue (flatten (map isIPv6 badAddrs));
    expected = false;
  };

  test-isIPv6CIDR = {
    expr = anyTrue (flatten (map isIPv6CIDR goodAddrs));
    expected = false;
  };

  test-isIPv6CIDR-good-upper-case = {
    expr = anyTrue (flatten (map (x: isIPv6CIDR (toUpper x)) goodAddrs));
    expected = false;
  };

  test-isIPv6CIDR-cidr-0 = rec {
    addrs = map (x: x + "/0") goodAddrs;
    expr = allTrue (flatten (map isIPv6CIDR addrs));
    expected = true;
  };

  test-isIPv6CIDR-cidr-128 = rec {
    addrs = map (x: x + "/128") goodAddrs;
    expr = allTrue (flatten (map isIPv6CIDR addrs));
    expected = true;
  };

  test-isIPv6CIDR-scope-id-1 = rec {
    addrs = map (x: x + "%eth0") goodAddrs;
    expr = anyTrue (flatten (map isIPv6CIDR addrs));
    expected = false;
  };

  test-isIPv6CIDR-scope-id-2 = rec {
    addrs = map (x: x + "%wg0") goodAddrs;
    expr = anyTrue (flatten (map isIPv6CIDR addrs));
    expected = false;
  };

  test-isIPv6CIDR-scope-id-3 = rec {
    addrs = map (x: x + "%0") goodAddrs;
    expr = anyTrue (flatten (map isIPv6CIDR addrs));
    expected = false;
  };

  test-isIPv6CIDR-scope-id-plus-cidr = rec {
    addrs = map (x: x + "%eth0/64") goodAddrs;
    expr = allTrue (flatten (map isIPv6CIDR addrs));
    expected = true;
  };

  test-isIPv6CIDR-scope-id-plus-cidr-2 = rec {
    addrs = map (x: x + "%wg0/56") goodAddrs;
    expr = allTrue (flatten (map isIPv6CIDR addrs));
    expected = true;
  };

  test-isIPv6CIDR-scope-id-plus-cidr-3 = rec {
    addrs = map (x: x + "%0/32") goodAddrs;
    expr = allTrue (flatten (map isIPv6CIDR addrs));
    expected = true;
  };

  test-isIPv6CIDR-bad-cidr-1 = rec {
    addrs = map (x: x + "/129") goodAddrs;
    expr = anyTrue (flatten (map isIPv6CIDR addrs));
    expected = false;
  };

  test-isIPv6CIDR-bad-cidr-2 = rec {
    addrs = map (x: x + "/a") goodAddrs;
    expr = anyTrue (flatten (map isIPv6CIDR addrs));
    expected = false;
  };

  test-isIPv6CIDR-bad-cidr-3 = rec {
    addrs = map (x: x + "/2a") goodAddrs;
    expr = anyTrue (flatten (map isIPv6CIDR addrs));
    expected = false;
  };

  test-isIPv6CIDR-bad = {
    expr = anyTrue (flatten (map isIPv6CIDR badAddrs));
    expected = false;
  };

  test-isIPv6NoCIDR = {
    expr = allTrue (flatten (map isIPv6NoCIDR goodAddrs));
    expected = true;
  };

  test-isIPv6NoCIDR-good-upper-case = {
    expr = allTrue (flatten (map (x: isIPv6NoCIDR (toUpper x)) goodAddrs));
    expected = true;
  };

  test-isIPv6NoCIDR-cidr-0 = rec {
    addrs = map (x: x + "/0") goodAddrs;
    expr = anyTrue (flatten (map isIPv6NoCIDR addrs));
    expected = false;
  };

  test-isIPv6NoCIDR-cidr-128 = rec {
    addrs = map (x: x + "/128") goodAddrs;
    expr = anyTrue (flatten (map isIPv6NoCIDR addrs));
    expected = false;
  };

  test-isIPv6NoCIDR-scope-id-1 = rec {
    addrs = map (x: x + "%eth0") goodAddrs;
    expr = allTrue (flatten (map isIPv6NoCIDR addrs));
    expected = true;
  };

  test-isIPv6NoCIDR-scope-id-2 = rec {
    addrs = map (x: x + "%wg0") goodAddrs;
    expr = allTrue (flatten (map isIPv6NoCIDR addrs));
    expected = true;
  };

  test-isIPv6NoCIDR-scope-id-3 = rec {
    addrs = map (x: x + "%0") goodAddrs;
    expr = allTrue (flatten (map isIPv6NoCIDR addrs));
    expected = true;
  };

  test-isIPv6NoCIDR-scope-id-plus-cidr = rec {
    addrs = map (x: x + "%eth0/64") goodAddrs;
    expr = anyTrue (flatten (map isIPv6NoCIDR addrs));
    expected = false;
  };

  test-isIPv6NoCIDR-scope-id-plus-cidr-2 = rec {
    addrs = map (x: x + "%wg0/56") goodAddrs;
    expr = anyTrue (flatten (map isIPv6NoCIDR addrs));
    expected = false;
  };

  test-isIPv6NoCIDR-scope-id-plus-cidr-3 = rec {
    addrs = map (x: x + "%0/32") goodAddrs;
    expr = anyTrue (flatten (map isIPv6NoCIDR addrs));
    expected = false;
  };

  test-isIPv6NoCIDR-bad-cidr-1 = rec {
    addrs = map (x: x + "/129") goodAddrs;
    expr = anyTrue (flatten (map isIPv6NoCIDR addrs));
    expected = false;
  };

  test-isIPv6NoCIDR-bad-cidr-2 = rec {
    addrs = map (x: x + "/a") goodAddrs;
    expr = anyTrue (flatten (map isIPv6NoCIDR addrs));
    expected = false;
  };

  test-isIPv6NoCIDR-bad-cidr-3 = rec {
    addrs = map (x: x + "/2a") goodAddrs;
    expr = anyTrue (flatten (map isIPv6NoCIDR addrs));
    expected = false;
  };

  test-isIPv6NoCIDR-bad = {
    expr = anyTrue (flatten (map isIPv6NoCIDR badAddrs));
    expected = false;
  };

  # Note -- it is an evaluation error to call ipv6Addr or ipv6CIDRSuffix
  # on an invalid IPv6 address.
  
  test-ipv6CIDRSuffix-1 = {
    expr = ipv6CIDRSuffix (parseIPv6 "2001::1/128");
    expected = [128];
  };

  test-ipv6CIDRSuffix-2 = {
    expr = ipv6CIDRSuffix (parseIPv6 "::ffff:1/32");
    expected = [32];
  };

  test-ipv6CIDRSuffix-3 = {
    expr = ipv6CIDRSuffix (parseIPv6 "1234::1/64");
    expected = [64];
  };

  test-ipv6CIDRSuffix-4 = {
    expr = ipv6CIDRSuffix (parseIPv6 "1234::1%eth0/64");
    expected = [64];
  };

  test-ipv6CIDRSuffix-5 = {
    expr = ipv6CIDRSuffix (parseIPv6 "1234::1");
    expected = [];
  };

  test-ipv6CIDRSuffix-6 = {
    expr = ipv6CIDRSuffix (parseIPv6 "::1");
    expected = [];
  };

  test-ipv6CIDRSuffix-7 = {
    expr = ipv6CIDRSuffix (parseIPv6 "::");
    expected = [];
  };

  test-ipv6Addr-1 = {
    expr = ipv6Addr (parseIPv6 "2001::1/128");
    expected = "2001::1";
  };

  test-ipv6Addr-2 = {
    expr = ipv6Addr (parseIPv6 "::ffff:1/32");
    expected = "::ffff:1";
  };

  test-ipv6Addr-3 = {
    expr = ipv6Addr (parseIPv6 "1234::1/64");
    expected = "1234::1";
  };

  test-ipv6Addr-4 = {
    expr = ipv6Addr (parseIPv6 "1234::1%eth0/64");
    expected = "1234::1%eth0";
  };

  test-ipv6Addr-5 = {
    expr = ipv6Addr (parseIPv6 "1234::1");
    expected = "1234::1";
  };

  test-ipv6Addr-6 = {
    expr = ipv6Addr (parseIPv6 "::1");
    expected = "::1";
  };

  test-ipv6Addr-7 = {
    expr = ipv6Addr (parseIPv6 "::");
    expected = "::";
  };

  test-unparseIPv6-good = {
    expr = map unparseIPv6 (map parseIPv6 goodAddrs);
    expected = goodAddrs;
  };

  test-unparseIPv6-good-upper-case = {
    expr = map unparseIPv6 (map (x: parseIPv6 (toUpper x)) goodAddrs);
    expected = map toUpper goodAddrs;
  };

  test-unparseIPv6-cidr-0 = rec {
    addrs = map (x: x + "/0") goodAddrs;
    expr = map unparseIPv6 (map parseIPv6 addrs);
    expected = addrs;
  };

  test-unparseIPv6-cidr-128 = rec {
    addrs = map (x: x + "/128") goodAddrs;
    expr = map unparseIPv6 (map parseIPv6 addrs);
    expected = addrs;
  };

  test-unparseIPv6-scope-id-1 = rec {
    addrs = map (x: x + "%eth0") goodAddrs;
    expr = map unparseIPv6 (map parseIPv6 addrs);
    expected = addrs;
  };

  test-unparseIPv6-scope-id-2 = rec {
    addrs = map (x: x + "%wg0") goodAddrs;
    expr = map unparseIPv6 (map parseIPv6 addrs);
    expected = addrs;
  };

  test-unparseIPv6-scope-id-3 = rec {
    addrs = map (x: x + "%0") goodAddrs;
    expr = map unparseIPv6 (map parseIPv6 addrs);
    expected = addrs;
  };

  test-unparseIPv6-scope-id-plus-cidr = rec {
    addrs = map (x: x + "%eth0/64") goodAddrs;
    expr = map unparseIPv6 (map parseIPv6 addrs);
    expected = addrs;
  };

  test-unparseIPv6-scope-id-plus-cidr-2 = rec {
    addrs = map (x: x + "%wg0/56") goodAddrs;
    expr = map unparseIPv6 (map parseIPv6 addrs);
    expected = addrs;
  };

  test-unparseIPv6-scope-id-plus-cidr-3 = rec {
    addrs = map (x: x + "%0/32") goodAddrs;
    expr = map unparseIPv6 (map parseIPv6 addrs);
    expected = addrs;
  };

}
