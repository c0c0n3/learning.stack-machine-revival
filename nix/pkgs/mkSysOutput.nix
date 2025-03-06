#
# Function to generate the Flake output for a given system.
#
{ # System label---e.g. "x86_64-linux", "x86_64-darwin", etc.
  system,
  # The Nix package set for the input system, possibly with
  # overlays from other Flakes bolted on.
  sysPkgs,
  ...
}:
{
  defaultPackage.${system} = with sysPkgs;
  let
    hbase = haskell.packages.ghc9121.ghcWithPackages (ps: []);    # (1)
  in buildEnv {
    name = "stack-machine-revival-shell";
    paths = [ hbase cabal-install ];
  };

  packages.${system} = {
    # Haskell packages and apps we'll build
  };

}
# NOTE
# ----
# 1. Could use Haskell env from Nixie. Bring it in if really needed
# though, since it comes with lots of packages. Or switch over to
# Horizon Haskell:
# - https://horizon-haskell.net/
#
