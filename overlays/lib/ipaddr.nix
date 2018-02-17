## Useful functions for dealing with IP addresses that are represented as strings.

{ lib
, ...
}:

with lib;

let

  stringTail = x: builtins.substring 1 (builtins.stringLength x) x;


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
  parseV4 = s:
    let
      good = builtins.match "^([[:digit:]]+)\\.([[:digit:]]+)\\.([[:digit:]]+)\\.([[:digit:]]+)(/[[:digit:]]+)?$" s;
      parse = if good == null then [] else good;
      octets = map toInt (v4Addr parse);
      suffix = map (x: toInt (stringTail x)) (v4CidrSuffix parse);
    in
      if (parse != [])              &&
         (all (x: x <= 255) octets) &&
         (all (x: x <= 32) suffix)
      then octets ++ suffix
      else [];

  isV4 = s: (parseV4 s) != [];


  ## These functions deal with IPv4 addresses expressed in list
  ## format, e.g., [ 10 0 10 1 24 ] for 10.0.10.1/24, or [ 10 0 10 1 ]
  ## for 10.0.10.1 (no CIDR suffix).

  v4Addr = sublist 0 4;

  v4CidrSuffix = sublist 4 4;

  # [ 10 0 10 1 ] -> "10.0.10.1"
  # [ 10 0 10 1 24 ] -> "10.0.10.1/24"
  # [ 10 0 1000 1 ] -> ""
  # [ 10 0 10 ] -> ""
  # [ 10 0 10 1 24 3] -> ""
  # [ 10 0 10 1 33 ] -> ""
  # [ "10" "0" "10" "1" ] -> evaluation error
  unparseV4 = l:
    let
      octets = v4Addr l;
      suffix = v4CidrSuffix l;
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
  
in
{
  inherit parseV4;
  inherit isV4;

  inherit v4Addr v4CidrSuffix;
  inherit unparseV4;
}
