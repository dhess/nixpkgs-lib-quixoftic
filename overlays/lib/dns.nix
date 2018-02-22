## DNS-related stuff.

{ lib
, ...
}:

let

  ## Google Public DNS servers.

  googleV4DNS = [ "8.8.8.8" "8.8.4.4" ];
  googleV6DNS = [ "2001:4860:4860::8888" "2001:4860:4860::8844" ];
  googleDNS = googleV4DNS ++ googleV6DNS;

in
{
  inherit googleV4DNS googleV6DNS googleDNS;
}
