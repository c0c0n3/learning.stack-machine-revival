{
  description = "Dev tools, packages and apps.";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs";  # master branch on 06 Mar 2025
    nixie = {
      url = "github:c0c0n3/nixie";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixie }:
  let
    inputPkgs = nixpkgs // {
      mkOverlays = system: [
        (final: prev: {
          inherit nixie;
        })
      ];
    };
    build = nixie.lib.flakes.mkOutputSetForCoreSystems inputPkgs;
    pkgs = build (import ./pkgs/mkSysOutput.nix);
  in
    pkgs;
}
