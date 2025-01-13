# Benchmarks matrix arithmetic lib

## Run benchmarks

Uncomment the `main` function in `project/src/main.nr` that should be benchmarked and run:
```=bash
$ nargo compile
$ bb gates -b target/project.json
#OR
$ bb gates -b target/project.json >> output.txt
```
The last command can be helpful when the gatecount is high and the output to the console could get confusing.

## Output (Jan 2025)

Addition, subtraction, scalar multiplication have equal costs:
- 50x50 matrix: 2.516 gates
- 100x100 matrix: 10.016 gates

Dot product for two vectors of 100 entries: 100 gates. Trace of a 100x100 matrix: 50 gates. 

Matrix multiplication:
- 50x30 x 30x60: 90.016 gates
- 50x50: 125.016 gates
- 100x100: 1.000.016 gates
- 100x120 x 120x110: 1.320.016 gates