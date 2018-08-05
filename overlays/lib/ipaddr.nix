## Useful functions for dealing with IP addresses that are represented as strings.

{ lib
, ...
}:

with lib;

let

  ## These functions deal with IPv4 addresses expressed as a string.
  
  # Note: does not handle "terse" CIDR syntax, e.g., "10.0.10/24" does
  # not parse.
  #
  # "10.0.10.1" -> [ 10 0 10 1 ]
  # "10.0.10.1/24" -> [ 10 0 10 1 24]
  # "10.0.10/24" -> []
  # "1000.0.10.1" -> []
  # "10.0.10.1/33" -> []
  # "abc" -> []
  parseIPv4 = s:
    let
      good = builtins.match "^([[:digit:]]+)\\.([[:digit:]]+)\\.([[:digit:]]+)\\.([[:digit:]]+)(/[[:digit:]]+)?$" s;
      parse = if good == null then [] else good;
      octets = map toInt (ipv4Addr parse);
      suffix =
        let
          suffix' = ipv4CIDRSuffix parse;
        in
          if (suffix' == [] || suffix' == [null])
          then []
          else map (x: toInt (removePrefix "/" x)) suffix';
    in
      if (parse != [])              &&
         (all (x: x <= 255) octets) &&
         (all (x: x <= 32) suffix)
      then octets ++ suffix
      else [];

  isIPv4 = s: (parseIPv4 s) != [];

  isIPv4CIDR = s:
    let
      l = parseIPv4 s;
    in
      l != [] && (ipv4CIDRSuffix l) != [];

  isIPv4NoCIDR = s:
    let
      l = parseIPv4 s;
    in
      l != [] && (ipv4CIDRSuffix l) == [];

  isIPv4RFC1918 = s:
    let
      parse = parseIPv4 s;
    in
      if parse == []
      then false
      else
        let
          suffix = ipv4CIDRSuffix parse;
          octet1 = elemAt parse 0;
          octet2 = elemAt parse 1;
          block1 = octet1 == 10 && (suffix == [] || head suffix >= 8);
          block2 = octet1 == 172 && (octet2 >= 16 && octet2 < 32) && (suffix == [] || head suffix >= 12);
          block3 = octet1 == 192 && octet2 == 168 && (suffix == [] || head suffix >= 16);
        in
          block1 || block2 || block3;


  ## These functions deal with IPv4 addresses expressed in list
  ## format, e.g., [ 10 0 10 1 24 ] for 10.0.10.1/24, or [ 10 0 10 1 ]
  ## for 10.0.10.1 (no CIDR suffix).

  ipv4Addr = take 4;
  ipv4CIDRSuffix = drop 4;

  # [ 10 0 10 1 ] -> "10.0.10.1"
  # [ 10 0 10 1 24 ] -> "10.0.10.1/24"
  # [ 10 0 1000 1 ] -> ""
  # [ 10 0 10 ] -> ""
  # [ 10 0 10 1 24 3] -> ""
  # [ 10 0 10 1 33 ] -> ""
  # [ "10" "0" "10" "1" ] -> evaluation error
  unparseIPv4 = l:
    let
      octets = ipv4Addr l;
      suffix = ipv4CIDRSuffix l;
    in
      if (length l < 4)                     ||
         (length l > 5)                     ||
         (any (x: x < 0 || x > 255) octets) ||
         (any (x: x < 0 || x > 32) suffix)
      then ""
      else
        let
          addr = concatMapStringsSep "." toString octets;
          suffix' = concatMapStrings toString suffix;
        in
          if suffix' == ""
          then addr
          else concatStringsSep "/" [ addr suffix' ];
  

  ## These functions deal with IPv6 addresses expressed as a string.

  # Note: this regex was originally generated by Phil Pennock's RFC
  # 3986-based generator, from here:
  #
  # https://people.spodhuis.org/phil.pennock/software/emit_ipv6_regexp-0.304
  #
  # It was then adapted to work with Nix's `builtins.match` regex
  # parser, and support added for scope IDs (e.g., %eth0) and prefix
  # sizes (e.g., /32).
  #
  # The final regex is a bit too liberal in the following ways (that
  # are known):
  #
  # - This regex will accept a scope ID (e.g., "%eth0") on any IPv6
  #   address, whereas according to the spec, it should only accept
  #   them for non-global scoped addresses.
  #
  # - It will accept IPv4-embedded IPv6 address formats and prefixes
  #   that are not RFC 6052-compliant.
  #
  # - If a CIDR suffix is present (e.g., /128), the regex only checks
  #   that the prefix is one or more digits; it does not check that
  #   the value is <= 128.

  rfc3986 = "(((((([[:xdigit:]]{1,4})):){6})((((([[:xdigit:]]{1,4})):(([[:xdigit:]]{1,4})))|(((((25[0-5]|([1-9]|1[0-9]|2[0-4])?[0-9]))\.){3}((25[0-5]|([1-9]|1[0-9]|2[0-4])?[0-9])))))))|((::((([[:xdigit:]]{1,4})):){5})((((([[:xdigit:]]{1,4})):(([[:xdigit:]]{1,4})))|(((((25[0-5]|([1-9]|1[0-9]|2[0-4])?[0-9]))\.){3}((25[0-5]|([1-9]|1[0-9]|2[0-4])?[0-9])))))))|((((([[:xdigit:]]{1,4})))?::((([[:xdigit:]]{1,4})):){4})((((([[:xdigit:]]{1,4})):(([[:xdigit:]]{1,4})))|(((((25[0-5]|([1-9]|1[0-9]|2[0-4])?[0-9]))\.){3}((25[0-5]|([1-9]|1[0-9]|2[0-4])?[0-9])))))))|(((((([[:xdigit:]]{1,4})):){0,1}(([[:xdigit:]]{1,4})))?::((([[:xdigit:]]{1,4})):){3})((((([[:xdigit:]]{1,4})):(([[:xdigit:]]{1,4})))|(((((25[0-5]|([1-9]|1[0-9]|2[0-4])?[0-9]))\.){3}((25[0-5]|([1-9]|1[0-9]|2[0-4])?[0-9])))))))|(((((([[:xdigit:]]{1,4})):){0,2}(([[:xdigit:]]{1,4})))?::((([[:xdigit:]]{1,4})):){2})((((([[:xdigit:]]{1,4})):(([[:xdigit:]]{1,4})))|(((((25[0-5]|([1-9]|1[0-9]|2[0-4])?[0-9]))\.){3}((25[0-5]|([1-9]|1[0-9]|2[0-4])?[0-9])))))))|(((((([[:xdigit:]]{1,4})):){0,3}(([[:xdigit:]]{1,4})))?::(([[:xdigit:]]{1,4})):)((((([[:xdigit:]]{1,4})):(([[:xdigit:]]{1,4})))|(((((25[0-5]|([1-9]|1[0-9]|2[0-4])?[0-9]))\.){3}((25[0-5]|([1-9]|1[0-9]|2[0-4])?[0-9])))))))|(((((([[:xdigit:]]{1,4})):){0,4}(([[:xdigit:]]{1,4})))?::)((((([[:xdigit:]]{1,4})):(([[:xdigit:]]{1,4})))|(((((25[0-5]|([1-9]|1[0-9]|2[0-4])?[0-9]))\.){3}((25[0-5]|([1-9]|1[0-9]|2[0-4])?[0-9])))))))|(((((([[:xdigit:]]{1,4})):){0,5}(([[:xdigit:]]{1,4})))?::)(([[:xdigit:]]{1,4})))|(((((([[:xdigit:]]{1,4})):){0,6}(([[:xdigit:]]{1,4})))?::)))(%[^/]+)?(/[[:digit:]]+)?";

  parseIPv6 = s:
    let
      # Note that if the parse matches, we still have to check the
      # prefix (if given) is <= 128. This is a bit clumsy.
      good = builtins.match "^(${rfc3986})$" s;
      parse = if good == null then [] else take 1 good;
      suffix = if parse == [] then [] else ipv6CIDRSuffix parse;
    in
      if (suffix == [])
      then parse
      else
        if (head suffix <= 128) then parse else [];

  isIPv6 = s: (parseIPv6 s) != [];

  isIPv6CIDR = s:
    let
      l = parseIPv6 s;
    in
      l != [] && (ipv6CIDRSuffix l) != [];

  isIPv6NoCIDR = s:
    let
      l = parseIPv6 s;
    in
      l != [] && (ipv6CIDRSuffix l) == [];


  ## These functions deal with IPv6 addresses represented as a
  ## single-element string array (post-`parseIPv6`).

  ipv6CIDRSuffix = l:
    let
      addr = head l;
      suffix = tail (splitString "/" addr);
    in
      if suffix == [] then [] else map toInt suffix;

  ipv6Addr = l:
    let
      addr = head l;
    in
      head (splitString "/" addr);

  unparseIPv6 = l: if l == [] then "" else head l;


  ## Convenience functions.

  prefixLengthToNetmask = prefixLength:
    assert (prefixLength >= 0 && prefixLength < 33);
    if prefixLength == 0  then "0.0.0.0"         else
    if prefixLength == 1  then "128.0.0.0"       else
    if prefixLength == 2  then "192.0.0.0"       else
    if prefixLength == 3  then "224.0.0.0"       else
    if prefixLength == 4  then "240.0.0.0"       else
    if prefixLength == 5  then "248.0.0.0"       else
    if prefixLength == 6  then "252.0.0.0"       else
    if prefixLength == 7  then "254.0.0.0"       else
    if prefixLength == 8  then "255.0.0.0"       else
    if prefixLength == 9  then "255.128.0.0"     else
    if prefixLength == 10 then "255.192.0.0"     else
    if prefixLength == 11 then "255.224.0.0"     else
    if prefixLength == 12 then "255.240.0.0"     else
    if prefixLength == 13 then "255.248.0.0"     else
    if prefixLength == 14 then "255.252.0.0"     else
    if prefixLength == 15 then "255.254.0.0"     else
    if prefixLength == 16 then "255.255.0.0"     else
    if prefixLength == 17 then "255.255.128.0"   else
    if prefixLength == 18 then "255.255.192.0"   else
    if prefixLength == 19 then "255.255.224.0"   else
    if prefixLength == 20 then "255.255.240.0"   else
    if prefixLength == 21 then "255.255.248.0"   else
    if prefixLength == 22 then "255.255.252.0"   else
    if prefixLength == 23 then "255.255.254.0"   else
    if prefixLength == 24 then "255.255.255.0"   else
    if prefixLength == 25 then "255.255.255.128" else
    if prefixLength == 26 then "255.255.255.192" else
    if prefixLength == 27 then "255.255.255.224" else
    if prefixLength == 28 then "255.255.255.240" else
    if prefixLength == 29 then "255.255.255.248" else
    if prefixLength == 30 then "255.255.255.252" else
    if prefixLength == 31 then "255.255.255.254" else
    "255.255.255.255";

in
{
  inherit parseIPv4;
  inherit isIPv4 isIPv4CIDR isIPv4NoCIDR isIPv4RFC1918;

  inherit ipv4Addr ipv4CIDRSuffix;
  inherit unparseIPv4;

  inherit prefixLengthToNetmask;

  inherit parseIPv6;
  inherit isIPv6 isIPv6CIDR isIPv6NoCIDR;

  inherit ipv6Addr ipv6CIDRSuffix;
  inherit unparseIPv6;
}
