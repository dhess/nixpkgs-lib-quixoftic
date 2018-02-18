## Additional useful types, mostly for NixOS modules.

{ lib
, ...
}:

with lib;

let

  addCheckDesc = desc: elemType: check: types.addCheck elemType check
    // { description = "${elemType.description} (with check: ${desc})"; };

in rec
{
  ## String types.

  nonEmptyStr = addCheckDesc "non-empty" types.str
    (x: x != "" && ! (all (c: c == " " || c == "\t") (stringToCharacters x)));


  ## IP addresses.

  ipv4 = addCheckDesc "valid IPv4 address" types.str ipaddr.isIPv4;
  ipv4CIDR = addCheckDesc "valid IPv4 address with CIDR suffix" types.str ipaddr.isIPv4CIDR;
  ipv4NoCIDR = addCheckDesc "valid IPv4 address, no CIDR suffix" types.str ipaddr.isIPv4NoCIDR;

  ipv6 = addCheckDesc "valid IPv6 address" types.str ipaddr.isIPv6;
  ipv6CIDR = addCheckDesc "valid IPv6 address with CIDR suffix" types.str ipaddr.isIPv6CIDR;
  ipv6NoCIDR = addCheckDesc "valid IPv6 address, no CIDR suffix" types.str ipaddr.isIPv6NoCIDR;


  ## Integer types.

  # Port 0 is sometimes used to indicate a "don't-care".
  port = types.ints.between 0 65535;
}
