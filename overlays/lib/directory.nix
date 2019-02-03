## Thanks to:
##
## https://github.com/dtzWill/nur-packages/commit/f601a6b024ac93f7ec242e6e3dbbddbdcf24df0b#diff-a013e20924130857c649dd17226282ff

self: super:

let

  listDirectory = action: dir:
  let
    list = builtins.readDir dir;
    names = builtins.attrNames list;
    allowedName = baseName: !(
      # From lib/sources.nix, ignore editor backup/swap files
      builtins.match "^\\.sw[a-z]$" baseName != null ||
      builtins.match "^\\..*\\.sw[a-z]$" baseName != null ||
      # Otherwise it's good
      false);
    filteredNames = builtins.filter allowedName names;
  in builtins.listToAttrs (builtins.map
    (name: {
      name = builtins.replaceStrings [".nix"] [""] name;
      value = action (dir + ("/" + name));
    })
    filteredNames);

  pathDirectory = listDirectory (d: d);
  importDirectory = listDirectory import;
  mkCallDirectory = callPkgs: listDirectory (p: callPkgs p {});

in
{
  lib = (super.lib or {}) // {
    inherit listDirectory pathDirectory importDirectory mkCallDirectory;
  };
}
