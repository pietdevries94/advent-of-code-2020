{pkgs}: let
  lib = pkgs.lib;

  input = builtins.readFile ./input;
  instructions = lib.strings.splitString "\n" input;

  getInstr = i: builtins.fromJSON (builtins.elemAt instructions i);

  initialList = builtins.genList (x: getInstr x) 25;

  hasPair = total: list: let
    needle = total - (builtins.elemAt list 0);
    newList = builtins.tail list;
    found = builtins.any (x: x == needle) newList;
  in
    if found
    then true
    else if (builtins.length newList) < 2
    then false
    else (hasPair total newList);

  findFirstWithoutPair = i: list: let
    cur = getInstr i;
  in
    if hasPair cur list
    then findFirstWithoutPair (i + 1) ((builtins.tail list) ++ [cur])
    else cur;

  part1 = findFirstWithoutPair 25 initialList;

  initialPair = [(builtins.fromJSON (builtins.elemAt instructions 0)) (builtins.fromJSON (builtins.elemAt instructions 1))];

  getTotal = l: builtins.foldl' (res: cur: res + cur) 0 l;

  getPart2Sum = list:
    (builtins.foldl' (res: cur: rec {
      min =
        if res.min == null || res.min < cur
        then cur
        else res.min;
      max =
        if res.max == null || res.max > cur
        then cur
        else res.max;
      total = min + max;
    })) {
      min = null;
      max = null;
    }
    list;

  findList = i: list: let
    total = getTotal list;
  in
    if total == part1
    then (getPart2Sum list).total
    else if (builtins.length list) == 2 || total < part1
    then (findList (i + 1) (list ++ [(getInstr i)]))
    else (findList i (builtins.tail list));

  part2 = findList 2 initialPair;
in {
  inherit part1 part2;
}
