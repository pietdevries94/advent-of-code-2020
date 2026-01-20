{pkgs}: let
  lib = pkgs.lib;

  input = builtins.readFile ./input;
  passports = lib.strings.splitString "\n\n" input;

  passPortIsValid = p: lib.strings.hasInfix "byr:" p && lib.strings.hasInfix "iyr:" p && lib.strings.hasInfix "eyr:" p && lib.strings.hasInfix "hgt:" p && lib.strings.hasInfix "hcl:" p && lib.strings.hasInfix "ecl:" p && lib.strings.hasInfix "pid:" p;

  validPassports = builtins.filter passPortIsValid passports;
in {
  part1 = builtins.length validPassports;
}
