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

  ipv4 = addCheckDesc "valid IPv4 address" types.str ipaddr.isV4;
  ipv4Cidr = addCheckDesc "valid IPv4 address with CIDR suffix" types.str ipaddr.isV4Cidr;
  ipv4NoCidr = addCheckDesc "valid IPv4 address, no CIDR suffix" types.str ipaddr.isV4NoCidr;

  ipv6 = addCheckDesc "valid IPv6 address" types.str ipaddr.isV6;
  ipv6Cidr = addCheckDesc "valid IPv6 address with CIDR suffix" types.str ipaddr.isV6Cidr;
  ipv6NoCidr = addCheckDesc "valid IPv6 address, no CIDR suffix" types.str ipaddr.isV6NoCidr;


  ## Integer types.

  # Port 0 is sometimes used to indicate a "don't-care".
  port = types.ints.between 0 65535;
}
