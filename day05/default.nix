{pkgs}: let
  lib = pkgs.lib;

  input = builtins.readFile ./input;
  binarySeats = lib.strings.splitString "\n" input;

  pow = base: exponent:
    if exponent == 0
    then 1
    else if exponent == 1
    then base
    else base * (pow base (exponent - 1));

  binaryToSeatId = x: let
    chars = lib.stringToCharacters x;
    res =
      builtins.foldl' (res: c: {
        pow = res.pow - 1;
        total =
          res.total
          + (
            if c == "B" || c == "R"
            then (pow 2 res.pow)
            else 0
          );
      }) {
        pow = (builtins.length chars) - 1;
        total = 0;
      }
      chars;
  in
    res.total;

  allSeats = builtins.sort (a: b: a > b) (builtins.map binaryToSeatId binarySeats);

  highestSeat = builtins.elemAt allSeats 0;

  mySeat =
    (builtins.foldl' (res: cur: {
        prev = cur;
        mine =
          if res.mine == null && (res.prev - cur) != 1
          then cur + 1
          else res.mine;
      }) {
        prev = highestSeat + 1;
        mine = null;
      }
      allSeats).mine;
in {
  part1 = highestSeat;
  part2 = mySeat;
}
