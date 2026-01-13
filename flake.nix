{
  description = "The flake for advent of code 2020";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... }: let
    pkgs = nixpkgs.legacyPackages.aarch64-darwin;
  in {
    day01 = import ./day01 { inherit pkgs; };
  };
}
