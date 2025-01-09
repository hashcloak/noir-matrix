# Matrix Arithmetic in Noir

**`noir-matrix`** is a matrix arithmetic library for [Noir](https://github.com/noir-lang/noir).

## Features

- Matrix addition, subtraction, and scalar multiplication
- Matrix multiplication
- Transpose operation
- Trace of square matrices (sum of diagonal elements)
- Dot product for vectors

## Example Usage

```noir
use matrix::{Matrix, trace, dot_product};

// Define a 3x2 matrix (3 rows and 2 columns)
let b = Matrix::<3, 2, Field> {
    data: [[1,2],[3,4],[5,6]], // an array for each tow
};

// Scalar multiplication
let scaled = a.scalar_mult(2);

// Define a 2x2 matrix
let b = Matrix::<2, 2, Field> {
    data: [[1, 2], [3, 4]],
};

// Trace of a square matrix
let tr = trace(b); // Result: 5 (1 + 4)

// Dot product of two vectors
let u = [1, 2, 3];
let v = [4, 5, 6];
let dot = dot_product(u, v); // Result: 32
```
