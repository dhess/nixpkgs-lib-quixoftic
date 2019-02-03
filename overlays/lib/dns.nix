self: super:

let

  ## Google Public DNS servers.

  googleV4DNS = [ "8.8.8.8" "8.8.4.4" ];
  googleV6DNS = [ "2001:4860:4860::8888" "2001:4860:4860::8844" ];
  googleDNS = googleV4DNS ++ googleV6DNS;


  ## Cloudflare Public DNS servers.

  cloudflareV4DNS = [ "1.1.1.1" "1.0.0.1" ];
  cloudflareV6DNS = [ "2606:4700:4700::1111" "2606:4700:4700::1001" ];
  cloudflareDNS = cloudflareV4DNS ++ cloudflareV6DNS;

  ## Cloudflare Public DNS servers, DNS over TLS with certificate checking.
  ##
  ## Note that this format is only useful with the Unbound recursive
  ## caching DNS server, in combination with with Unbound
  ## tls-cert-bundle and forward-tls-upstream directives.

  ipToTLS = ip: "${ip}@853#cloudflare-dns.com";
  cloudflareV4DNSOverTLS = map ipToTLS cloudflareV4DNS;
  cloudflareV6DNSOverTLS = map ipToTLS cloudflareV6DNS;
  cloudflareDNSOverTLS = cloudflareV4DNSOverTLS ++ cloudflareV6DNSOverTLS;

in
{
  lib = (super.lib or {}) // {
    dns = (super.lib.dns or {}) // {
      inherit googleV4DNS googleV6DNS googleDNS;
      inherit cloudflareV4DNS cloudflareV6DNS cloudflareDNS;
      inherit cloudflareV4DNSOverTLS cloudflareV6DNSOverTLS cloudflareDNSOverTLS;
    };
  };
}
