{pkgs}: let
  lib = pkgs.lib;

  input = builtins.readFile ./input;
  groups = builtins.map (x:
    builtins.foldl' (res: cur:
      if cur == "\n"
      then res // {numberOfPeople = res.numberOfPeople + 1;}
      else res // {chars = builtins.concatLists [res.chars [cur]];}) {
      numberOfPeople = 1;
      chars = [];
    } (lib.stringToCharacters x)) (lib.strings.splitString "\n\n" input);

  countGroup = group:
    builtins.foldl' (res: cur:
      res
      // {
        ${cur} = (res.${cur} or 0) + 1;
      }) {}
    group.chars;
  countedGroups =
    builtins.map (g: rec {
      counts = countGroup g;
      numberOfPeople = g.numberOfPeople;
      allPeopleCount = lib.filterAttrs (name: val: val == g.numberOfPeople) counts;
    })
    groups;

  part1 = builtins.foldl' (res: g: res + (builtins.length (builtins.attrNames g.counts))) 0 countedGroups;
  part2 = builtins.foldl' (res: g: res + (builtins.length (builtins.attrNames g.allPeopleCount))) 0 countedGroups;
in {
  inherit part1 part2;
}
