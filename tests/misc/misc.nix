# to run these tests:
# nix-instantiate --eval --strict misc.nix
# if the resulting list is empty, all tests passed

with import <nixpkgs> { };

with pkgs.lib;

runTests {

  test-exclusiveOr-1 = {
    expr = exclusiveOr false false;
    expected = false;
  };

  test-exclusiveOr-2 = {
    expr = exclusiveOr true true;
    expected = false;
  };

  test-exclusiveOr-3 = {
    expr = exclusiveOr true false;
    expected = true;
  };

  test-exclusiveOr-4 = {
    expr = exclusiveOr false true;
    expected = true;
  };

  test-googleV4DNS = {
    expr = dns.googleV4DNS;
    expected = [ "8.8.8.8" "8.8.4.4" ];
  };

  test-googleV6DNS = {
    expr = dns.googleV6DNS;
    expected = [ "2001:4860:4860::8888" "2001:4860:4860::8844" ];
  };

  test-googleDNS = {
    expr = dns.googleDNS;
    expected = [ "8.8.8.8" "8.8.4.4" "2001:4860:4860::8888" "2001:4860:4860::8844" ];
  };

  test-cloudflareV4DNS = {
    expr = dns.cloudflareV4DNS;
    expected = [ "1.1.1.1" "1.0.0.1" ];
  };

  test-cloudflareV6DNS = {
    expr = dns.cloudflareV6DNS;
    expected = [ "2606:4700:4700::1111" "2606:4700:4700::1001" ];
  };

  test-cloudflareDNS = {
    expr = dns.cloudflareDNS;
    expected = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
  };

  test-cloudflareV4DNSOverTLS = {
    expr = dns.cloudflareV4DNSOverTLS;
    expected = [ "1.1.1.1@853#cloudflare-dns.com" "1.0.0.1@853#cloudflare-dns.com" ];
  };

  test-cloudflareV6DNSOverTLS = {
    expr = dns.cloudflareV6DNSOverTLS;
    expected = [ "2606:4700:4700::1111@853#cloudflare-dns.com" "2606:4700:4700::1001@853#cloudflare-dns.com" ];
  };

  test-cloudflareDNSOverTLS = {
    expr = dns.cloudflareDNSOverTLS;
    expected = [ "1.1.1.1@853#cloudflare-dns.com" "1.0.0.1@853#cloudflare-dns.com" "2606:4700:4700::1111@853#cloudflare-dns.com" "2606:4700:4700::1001@853#cloudflare-dns.com" ];
  };

}
