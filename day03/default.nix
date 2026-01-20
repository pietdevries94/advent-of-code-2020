{pkgs}: let
  lib = pkgs.lib;

  input = builtins.readFile ./input;
  allLines = lib.strings.splitString "\n" input;
  lines = lib.sublist 1 ((builtins.length allLines) - 1) allLines;

  width = builtins.stringLength (builtins.elemAt lines 0);

  calculator = jump: every:
    builtins.foldl' (acc: val: let
      skip = (lib.trivial.mod acc.i every) != 0;

      place = lib.trivial.mod (acc.place + jump) width;
      el = builtins.substring place 1 val;

      newVal =
        (builtins.substring 0 place val)
        + (
          if el == "#"
          then "X"
          else "O"
        )
        + (builtins.substring (place + 1) width val);

      count =
        acc.count
        + (
          if el == "#"
          then 1
          else 0
        );
    in
      if skip
      then {
        place = acc.place;
        count = acc.count;
        i = acc.i + 1;
        str = acc.str + val + "\n";
      }
      else {
        inherit place count;
        i = acc.i + 1;
        str = acc.str + newVal + "\n";
      }) {
      i = 1;
      place = 0;
      count = 0;
      str = (builtins.elemAt allLines 0) + "\n";
    }
    lines;

  part1 = calculator 3 1;

  allSlopes = [
    (calculator 1 1)
    (calculator 3 1)
    (calculator 5 1)
    (calculator 7 1)
    (calculator 1 2)
  ];

  part2 = builtins.foldl' (acc: val: acc * val.count) 1 allSlopes;
in {
  part1 = part1.count;
  part2 = part2;
}
