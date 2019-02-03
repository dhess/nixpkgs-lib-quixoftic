# nixpkgs-lib-quixoftic

Library/utility functions for Nix projects, expressed as a Nix
overlay.

Unlike most Nix overlays, this overlay does not override any
derivations, nor does it define any new packages. It simply adds some
useful functions to an overlay's `self.lib`. It is meant to be
included by other overlays.

See the Nix files in `overlays` directory for documentation.

## Package set

This project can also be used as a
[NUR-style](https://github.com/nix-community/NUR) package set. To use
it this way, see the `package-set.nix` file.
