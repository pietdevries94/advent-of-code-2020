{pkgs}: let
  lib = pkgs.lib;

  line2set = line: let
    parts = builtins.filter (v: v != [] && v != "") (builtins.split "[ :-]" line);
  in {
    min = builtins.fromJSON (builtins.elemAt parts 0);
    max = builtins.fromJSON (builtins.elemAt parts 1);
    char = builtins.elemAt parts 2;
    string = builtins.elemAt parts 3;
  };

  input = builtins.readFile ./input;
  lines = lib.strings.splitString "\n" input;
  sets = builtins.map line2set lines;

  getCount = str: char: (builtins.length (lib.splitString char str)) - 1;
  part1 = builtins.filter (set: let count = getCount set.string set.char; in count >= set.min && count <= set.max) sets;

  charAtIndex = str: char: index:
    if (builtins.substring (index - 1) 1 str) == char
    then 1
    else 0;
  part2 = builtins.filter (set: let
    check = charAtIndex set.string set.char;
    count = (check set.min) + (check set.max);
  in
    count == 1)
  sets;
in {
  part1 = builtins.length part1;
  part2 = builtins.length part2;
}
