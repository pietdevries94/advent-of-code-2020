{pkgs}: let
  lib = pkgs.lib;

  input = builtins.readFile ./input;
  lines = lib.strings.splitString "\n" input;

  trimLast = l: builtins.substring 0 ((builtins.stringLength l) - 1) l;

  parseInner = outer: str: let
    matches = builtins.match "([0-9]+) (.*)" str;
    count = builtins.fromJSON (builtins.elemAt matches 0);
    bagRaw = builtins.elemAt matches 1;
    inner =
      if count == 1
      then bagRaw
      else trimLast bagRaw;
  in {
    inherit outer count inner;
  };

  parseLine = l: let
    parts = lib.splitString " contain " (trimLast l);
    outer = trimLast (builtins.elemAt parts 0);
    inners = builtins.filter (x: x != "no other bags") (lib.strings.splitString ", " (builtins.elemAt parts 1));
    res = builtins.foldl' (res: cur: res ++ [(parseInner outer cur)]) [] inners;
  in
    res;

  parsed = builtins.foldl' (res: cur: res ++ (parseLine cur)) [] lines;
  groupedByInner = builtins.groupBy (x: x.inner) parsed;

  findRec = found: let
    newOuters = builtins.foldl' (res: cur:
      res
      // builtins.listToAttrs (builtins.map (x: {
        name = x.outer;
        value = true;
      }) (builtins.getAttr cur groupedByInner)))
    found (builtins.filter (x: builtins.hasAttr x groupedByInner) (builtins.attrNames found));

    res =
      if builtins.length (builtins.attrNames found) == builtins.length (builtins.attrNames newOuters)
      then newOuters
      else (findRec newOuters);
  in
    res;

  allGoldenAndAround = findRec {"shiny gold bag" = true;};

  part1 = (builtins.length (builtins.attrNames allGoldenAndAround)) - 1;

  groupedByOuter = builtins.groupBy (x: x.outer) parsed;

  countBags = name:
    if (builtins.hasAttr name groupedByOuter)
    then builtins.foldl' (res: cur: res + (cur.count * (countBags cur.inner))) 1 (builtins.getAttr name groupedByOuter)
    else 1;

  part2 = (countBags "shiny gold bag") - 1;
in {
  inherit part1 part2;
}
