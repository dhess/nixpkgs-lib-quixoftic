# nixpkgs-lib-quixoftic

Library/utility functions for Nix projects, expressed as a Nix
overlay.

Unlike most Nix overlays, this overlay does not override any
derivations, nor does it define any new packages. It simply adds some
useful functions to an overlay's `self.lib`. It is meant to be
included by other overlays.
