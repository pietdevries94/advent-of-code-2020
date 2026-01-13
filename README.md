# Advent of Code 2020

This repository contains my solutions for the Advent of Code 2020 programming challenges. Each day's challenge is implemented in a separate file, organized by day.

I chose to solve these challenges using Nix, so I can learn it better while having fun with the puzzles.

## Running the Solutions
To run the solutions, you need Nix and flake support installed. The flake is set up for Darwin only, but it does not use any Darwin-specific features, so it should work on other systems as well, by making minor adjustments to the flake configuration.
You can run the solutions for each day using the following command:

```bash
nix eval .#day-<day-number>
```

Replace `<day-number>` with the specific day you want to run (e.g., `day-1`, `day-2`, etc.).
