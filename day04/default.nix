{pkgs}: let
  lib = pkgs.lib;

  input = builtins.readFile ./input;
  passports = lib.strings.splitString "\n\n" input;

  makePairs = doc: builtins.map (x: builtins.match ''([a-z]{3}):(.*)'' x) (builtins.filter (x: x != []) (builtins.split ''[[:space:]]'' doc));

  passportPairs = builtins.map makePairs passports;

  getKeys = pairs: builtins.map (x: builtins.elemAt x 0) pairs;
  allRequiredKeys = pair: (builtins.length (lib.lists.intersectLists ["byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid"] (getKeys pair))) == 7;

  validPassportPairsPart1 = builtins.filter allRequiredKeys passportPairs;

  makeSet = pairs: builtins.foldl' (acc: cur: acc // {${builtins.elemAt cur 0} = builtins.elemAt cur 1;}) {} pairs;

  toBeCheckedSets = builtins.map makeSet validPassportPairsPart1;

  byrCheck = s: let i = builtins.fromJSON s.byr; in i >= 1920 && i <= 2002;
  iyrCheck = s: let i = builtins.fromJSON s.iyr; in i >= 2010 && i <= 2020;
  eyrCheck = s: let i = builtins.fromJSON s.eyr; in i >= 2020 && i <= 2030;
  hgtCheck = s: let i = builtins.fromJSON (builtins.substring 0 ((builtins.stringLength s.hgt) - 2) s.hgt); in ((lib.strings.hasSuffix "cm" s.hgt) && i >= 150 && i <= 193) || ((lib.strings.hasSuffix "in" s.hgt) && i >= 59 && i <= 76);
  hclCheck = s: (builtins.match ''#[0-9a-f]{6}'' s.hcl) != null;
  eclCheck = s: builtins.elem s.ecl ["amb" "blu" "brn" "gry" "grn" "hzl" "oth"];
  pidCheck = s: (builtins.match ''[0-9]{9}'' s.pid) != null;

  allPart2Checks = s: (byrCheck s) && (iyrCheck s) && (eyrCheck s) && (hgtCheck s) && (hclCheck s) && (eclCheck s) && (pidCheck s);
  validPassportSetsPart2 = builtins.filter allPart2Checks toBeCheckedSets;
in {
  part1 = builtins.length validPassportPairsPart1;
  part2 = builtins.length validPassportSetsPart2;
}
