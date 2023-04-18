{
  description = "Nix flake of the sourcegraph-app";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
    in {
      sourcegraph-app = pkgs.callPackage ./sourcegraph-app.nix {};
    });

    defaultPackage = forAllSystems (system: self.packages.${system}.sourcegraph-app);
  };
}
