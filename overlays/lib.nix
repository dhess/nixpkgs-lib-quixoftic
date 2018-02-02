self: super:

let

  filterNix = name: type: let baseName = baseNameOf (toString name); in ! (
    type != "directory" && (
      super.lib.hasSuffix ".nix" baseName
    )
  );
  cleanSourceNix = src: super.lib.cleanSourceWith { filter = filterNix; inherit src; };

  filterHaskell = name: type: let baseName = baseNameOf (toString name); in ! (
    type == "directory" && (
      baseName == ".cabal-sandbox" ||
      baseName == ".stack-work"    ||
      baseName == "dist"           ||
      baseName == "dist-newstyle"
    ) ||
    type != "directory" && (
      baseName == ".ghci"                 ||
      baseName == ".stylish-haskell.yaml" ||
      baseName == "cabal.sandbox.config"
    )
  );
  cleanSourceHaskell = src: super.lib.cleanSourceWith { filter = filterHaskell; inherit src; };

  filterSystemCruft = name: type: let baseName = baseNameOf (toString name); in ! (
    type != "directory" && (
      baseName == ".DS_Store"
    )
  );
  cleanSourceSystemCruft = src: super.lib.cleanSourceWith { filter = filterSystemCruft; inherit src; };

  filterEditors = name: type: let baseName = baseNameOf (toString name); in ! (
    type != "directory" && (
      baseName == ".dir-locals.el"                         ||
      baseName == ".netrwhist"                             ||
      baseName == ".projectile"                            ||
      baseName == ".tags"                                  ||
      baseName == ".vim.custom"                            ||
      baseName == ".vscodeignore"                          ||
      builtins.match "^#.*#$" baseName != null             ||
      builtins.match "^\\.#.*$" baseName != null           ||
      builtins.match "^.*_flymake\\..*$" baseName != null  ||
      builtins.match "^flycheck_.*\\.el$" baseName != null
    )
  );
  cleanSourceEditors = src: super.lib.cleanSourceWith { filter = filterEditors; inherit src; };

  filterMaintainer = name: type: let baseName = baseNameOf (toString name); in ! (
    type != "directory" && (
      # Note: .git can be a file when it's in a submodule directory
      baseName == ".git"           ||
      baseName == ".gitattributes" ||
      baseName == ".gitignore"     ||
      baseName == ".gitmodules"    ||
      baseName == ".npmignore"     ||
      baseName == ".travis.yml"
    )
  );
  cleanSourceMaintainer = src: super.lib.cleanSourceWith { filter = filterMaintainer; inherit src; };

  cleanSourceAllExtraneous = src:
    cleanSourceMaintainer
      (cleanSourceEditors
        (cleanSourceSystemCruft
          (cleanSourceHaskell
            (cleanSourceNix
              (super.lib.cleanSource src)))));

  cleanPackage = cleanSrc: pkg: (pkg.overrideAttrs (oldAttrs: {
    src = cleanSrc oldAttrs.src;
  }));

in
{
  lib = (super.lib or {}) // {

    ## Functions for cleaning local source directories. These are
    ## useful for filtering out files in your local repo that should
    ## not contribute to a Nix hash, so that you can just `src = ./.`
    ## in your derivation, and then filter that attribute after the
    ## fact.
    ##
    ## Note that these functions are composable, e.g., cleanSourceNix
    ## (cleanCabalStack ...) is a valid expression. They will also
    ## compose with any `lib.cleanSourceWith` function (but *not* with
    ## `builtins.filterSource`; see the `lib.cleanSourceWith`
    ## documentation).
    
    # In most cases, I believe that filtering Nix files from the source
    # hash is the right thing to do. They're obviously already evaluated
    # when a nix-build command is executed, so if *what they evaluate*
    # changes they'll cause a rebuild anyway, as they should; while
    # cosmetic changes (comments, formatting, etc.) won't.
    inherit cleanSourceNix;

    # Clean Haskell projects.
    inherit cleanSourceHaskell;

    # Clean system cruft, e.g., .DS_Store files on macOS filesystems.    
    inherit cleanSourceSystemCruft;

    # Clean files related to editors and IDEs.
    inherit cleanSourceEditors;

    # Clean maintainer files that don't affect Nix builds.
    inherit cleanSourceMaintainer;

    # A cleaner that combines all of the cleaners defined here, plus
    # `lib.cleanSource` from Nixpkgs.
    inherit cleanSourceAllExtraneous;

    # Clean the `src` attribute of a package. This is convenient when
    # you use tools like `cabal2nix` to generate Nix files for local
    # source repos, as these tools generally lack the ability to
    # apply the various `clean*Source` functions to the `src`
    # attribute that they generate. Instead, you can apply this
    # function, plus one or more source cleaners, to a package that
    # is the result of a `callPackage` function application.
    inherit cleanPackage;
  };
}
