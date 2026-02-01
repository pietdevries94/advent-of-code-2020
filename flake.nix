{
  description = "The flake for advent of code 2020";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    pkgs = nixpkgs.legacyPackages.aarch64-darwin;
  in {
    day01 = import ./day01 {inherit pkgs;};
    day02 = import ./day02 {inherit pkgs;};
    day03 = import ./day03 {inherit pkgs;};
    day04 = import ./day04 {inherit pkgs;};
    day05 = import ./day05 {inherit pkgs;};
    day06 = import ./day06 {inherit pkgs;};
    day07 = import ./day07 {inherit pkgs;};
    day08 = import ./day08 {inherit pkgs;};
  };
}
