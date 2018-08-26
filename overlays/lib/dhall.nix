{ pkgs, lib, ... }:

let

  toNixFromFile = fileName:
  let
    source = builtins.readFile fileName;
  in
    pkgs.dhallToNix source;

in
{
  inherit toNixFromFile;
}
