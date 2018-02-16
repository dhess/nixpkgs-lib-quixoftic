## Additional useful types, mostly for NixOS modules.

{ lib }:

with lib;

let

  addCheckDesc = desc: elemType: check: types.addCheck elemType check
    // { description = "${elemType.description} (with check: ${desc})"; };

in rec
{
  ## String types.

  nonEmptyStr = addCheckDesc "non-empty" types.str
    (x: x != "" && ! (all (c: c == " " || c == "\t") (stringToCharacters x)));


  ## Integer types.

  # Port 0 is sometimes used to indicate a "don't-care".
  port = types.ints.between 0 65535;
}
