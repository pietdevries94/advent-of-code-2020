{pkgs}: let
  lib = pkgs.lib;

  input = builtins.readFile ./input;
  lines = lib.strings.splitString "\n" input;
  cleanlines = builtins.filter (v: v != "") lines;
  numbers = builtins.map builtins.fromJSON cleanlines;

  findNumForPart1 = n: lib.lists.findFirst (x: x + n == 2020) null numbers;

  p1_1 = lib.lists.findFirst (x: (findNumForPart1 x) != null) null numbers;
  p1_2 = findNumForPart1 p1_1;

  findNumForPart2 = n1: n2: lib.lists.findFirst (x: x + n1 + n2 == 2020) null numbers;
  findNumsForPart2 = n: lib.lists.findFirst (x: (findNumForPart2 n x) != null) null numbers;

  p2_1 = lib.lists.findFirst (x: (findNumsForPart2 x) != null) null numbers;
  p2_2 = findNumsForPart2 p2_1;
  p2_3 = findNumForPart2 p2_1 p2_2;
in {
  part1 = p1_1 * p1_2;
  part2 = p2_1 * p2_2 * p2_3;
}
