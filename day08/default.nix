{pkgs}: let
  lib = pkgs.lib;

  input = builtins.readFile ./input;
  instructions = lib.strings.splitString "\n" input;

  parseInstruction = s: let
    parts = builtins.match "([a-z]{3}) ([\-+])([0-9]+)" s;
    count = builtins.fromJSON (builtins.elemAt parts 2);
  in {
    type = builtins.elemAt parts 0;
    count =
      if (builtins.elemAt parts 1) == "-"
      then 0 - count
      else count;
  };

  target = builtins.length instructions;

  process = x: let
    instructionBeforeSwap = parseInstruction (builtins.elemAt instructions x.i);

    nthInstructionToSwap =
      if x.nthInstructionToSwap <= 0
      then -1
      else if instructionBeforeSwap.type == "jmp" || instructionBeforeSwap.type == "nop"
      then x.nthInstructionToSwap - 1
      else x.nthInstructionToSwap;

    instruction =
      if nthInstructionToSwap != 0
      then instructionBeforeSwap
      else
        instructionBeforeSwap
        // {
          type =
            if instructionBeforeSwap.type == "jmp"
            then "nop"
            else "jmp";
        };

    seen = x.seen // {"${builtins.toJSON x.i}" = true;};
    i =
      if instruction.type == "jmp"
      then x.i + instruction.count
      else x.i + 1;
    acc =
      if instruction.type == "acc"
      then x.acc + instruction.count
      else x.acc;
    infinite = builtins.hasAttr (builtins.toJSON i) seen;
    tooFar = i > target;
    end = i == target;

    res = {inherit seen i acc infinite tooFar end nthInstructionToSwap;};
  in
    if res.infinite || res.tooFar || res.end
    then res
    else (process res);

  processPart2 = x: let
    res = process {
      nthInstructionToSwap = x;
      i = 0;
      seen = {};
      acc = 0;
      infinite = false;
      tooFar = false;
      end = false;
    };
  in
    if res.end
    then res
    else (processPart2 (x + 1));

  part1 =
    (process {
      nthInstructionToSwap = -1;
      i = 0;
      seen = {};
      acc = 0;
      infinite = false;
      tooFar = false;
      end = false;
    }).acc;

  part2 =
    (processPart2 1).acc;
in {
  inherit part1 part2;
}
