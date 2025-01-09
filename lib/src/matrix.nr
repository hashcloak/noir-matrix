use std::ops::{Add, Sub, Mul};

// Matrix with M rows and N colums
// Example: 3 rows and 2 colums will be stored like this:
// [[1,2],[3,4],[5,6]], i.e each entry contains the full row
// Equals:
// 1 2 
// 3 4
// 5 6 
pub struct Matrix<let M: u32, let N: u32, T> {
    pub data: [[T; N]; M],
}

pub trait MatrixTrait<let M: u32, let N: u32, let K: u32, T>: Add + Sub 
where 
    T: Add + Sub + Mul + Default,
{
    pub fn new() -> Self;
    pub fn scalar_mult(self: Self, k: T) -> Self;
    // Multiply m x n matrix with a n x k matrix, resulting in a m x n matrix
    pub fn mult(self: Self, other: Matrix<N, K, T>) -> Matrix<M, K, T>;
}

impl<let M: u32, let N: u32, let K: u32, T> MatrixTrait<M, N, K, T> for Matrix<M, N, T>
where
    T: Add + Sub + Mul + Default,
{
    pub fn new() -> Self {
        Matrix { data: [[T::default(); N]; M] }
    }

    pub fn scalar_mult(a: Matrix<M, N, T>, k: T) -> Self {
        let mut res = Matrix::<M, N, T>::new();
        for i in 0..M { // rows
          for j in 0..N { // columns
            res.data[i][j] = k * a.data[i][j];
          }
        }
        res
    }

    pub fn mult(a: Matrix<M, N, T>, b: Matrix<N, K, T>) -> Matrix<M, K, T> {
      // Calling `new` here leads to error "while substituting (unbound): expected kind of unbound TypeVariable (Numeric(u32)) to match the kind of its binding (Normal)"
        let mut res = Matrix { data: [[T::default(); K]; M] };
        for i in 0..M { // rows of self
            for j in 0..K { // columns of other
                let mut sum = T::default();
                for k in 0..N { // shared dimension
                    sum = sum + a.data[i][k] * b.data[k][j];
                }
                res.data[i][j] = sum;
            }
        }
        res
    }
}

impl<let M: u32, let N: u32, T> Add for Matrix<M, N, T> 
where
    T: Add + Sub + Mul + Default,
{

    // Add 2 matrices by adding each of the elements
    fn add(self, other: Self) -> Self {
      // self and other are of the same size because of generics
        let mut res = Matrix::<M,N,T>::new();
        for i in 0..M { // rows
          for j in 0..N { // columns
            res.data[i][j] = self.data[i][j] + other.data[i][j];
          }
        }
        res
    }
}

impl<let M: u32, let N: u32, T> std::ops::Sub for Matrix<M, N, T> 
where
    T: Add + Sub + Mul + Default,
{

    // Subtract matrix from self by subtracting each of its elements
    fn sub(self, other: Self) -> Self {
      // self and other are of the same size because of generics
        let mut res = Matrix::<M, N, T>::new();
        for i in 0..M { // rows
          for j in 0..N { // columns
            res.data[i][j] = self.data[i][j] - other.data[i][j];
          }
        }
        res
    }
}

#[test]
fn test_matrix_addition() {
    // Test 1: Adding two 2x2 matrices with small positive values
    let a: Matrix<2, 2, Field> = Matrix {
        data: [[1, 2], [3, 4]],
    };
    let b: Matrix<2, 2, Field> = Matrix {
        data: [[5, 6], [7, 8]],
    };
    let result = a + b;

    // Expected: [[6, 8], [10, 12]]
    assert(result.data[0][0] == 6);
    assert(result.data[0][1] == 8);
    assert(result.data[1][0] == 10);
    assert(result.data[1][1] == 12);

    // Test 2: Adding zero matrix
    let zero: Matrix<2, 2, Field> = Matrix {
        data: [[0, 0], [0, 0]],
    };
    let result_zero = a + zero;

    // Expected: Same as `a`
    assert(result_zero.data[0][0] == 1);
    assert(result_zero.data[0][1] == 2);
    assert(result_zero.data[1][0] == 3);
    assert(result_zero.data[1][1] == 4);
}

#[test]
fn test_matrix_subtraction() {
    // Test 1: Subtracting two 2x2 matrices
    let a: Matrix<2, 2, Field> = Matrix {
        data: [[10, 12], [14, 16]],
    };
    let b: Matrix<2, 2, Field> = Matrix {
        data: [[1, 2], [3, 4]],
    };
    let result = a - b;

    // Expected: [[9, 10], [11, 12]]
    assert(result.data[0][0] == 9);
    assert(result.data[0][1] == 10);
    assert(result.data[1][0] == 11);
    assert(result.data[1][1] == 12);

    // Test 2: Subtracting a matrix from itself
    let result_self = a - a;

    // Expected: Zero matrix
    assert(result_self.data[0][0] == 0);
    assert(result_self.data[0][1] == 0);
    assert(result_self.data[1][0] == 0);
    assert(result_self.data[1][1] == 0);
}

#[test]
fn test_scalar_multiplication() {
    // Test 1: Scalar multiplication of a 2x2 matrix
    let a: Matrix<2, 2, Field> = Matrix {
        data: [[1, 2], [3, 4]],
    };
    let scalar: Field = 2;
    let result: Matrix<2, 2, Field> = Matrix::<2, 2, Field>::scalar_mult(a, scalar);

    // Expected: [[2, 4], [6, 8]]
    assert(result.data[0][0] == 2);
    assert(result.data[0][1] == 4);
    assert(result.data[1][0] == 6);
    assert(result.data[1][1] == 8);

    // Test 2: Scalar multiplication with zero
    let zero: Field = 0;
    let result_zero = Matrix::<2, 2, Field>::scalar_mult(a, zero);

    // Expected: Zero matrix
    assert(result_zero.data[0][0] == 0);
    assert(result_zero.data[0][1] == 0);
    assert(result_zero.data[1][0] == 0);
    assert(result_zero.data[1][1] == 0);
}

#[test]
fn test_matrix_multiplication_different_sizes() {
    // Test 1: Multiply a 2x3 matrix by a 3x2 matrix
    let a: Matrix<2, 3, Field> = Matrix {
        data: [[1, 2, 3], [4, 5, 6]],
    };
    let b: Matrix<3, 2, Field> = Matrix {
        data: [[7, 8], [9, 10], [11, 12]],
    };
    let result = a.mult(b);

    // Expected result: 2x2 matrix
    // [[1*7 + 2*9 + 3*11, 1*8 + 2*10 + 3*12],
    //  [4*7 + 5*9 + 6*11, 4*8 + 5*10 + 6*12]]
    // [[58, 64], [139, 154]]
    assert(result.data[0][0] == 58);
    assert(result.data[0][1] == 64);
    assert(result.data[1][0] == 139);
    assert(result.data[1][1] == 154);

    // Test 2: Multiply a 3x2 matrix by a 2x3 matrix
    let c: Matrix<3, 2, Field> = Matrix {
        data: [[1, 2], [3, 4], [5, 6]],
    };
    let d: Matrix<2, 3, Field> = Matrix {
        data: [[7, 8, 9], [10, 11, 12]],
    };
    let result_cd = c.mult(d);

    // Expected result: 3x3 matrix
    // [[1*7 + 2*10, 1*8 + 2*11, 1*9 + 2*12],
    //  [3*7 + 4*10, 3*8 + 4*11, 3*9 + 4*12],
    //  [5*7 + 6*10, 5*8 + 6*11, 5*9 + 6*12]]
    // [[27, 30, 33],
    //  [61, 68, 75],
    //  [95, 106, 117]]
    assert(result_cd.data[0][0] == 27);
    assert(result_cd.data[0][1] == 30);
    assert(result_cd.data[0][2] == 33);
    assert(result_cd.data[1][0] == 61);
    assert(result_cd.data[1][1] == 68);
    assert(result_cd.data[1][2] == 75);
    assert(result_cd.data[2][0] == 95);
    assert(result_cd.data[2][1] == 106);
    assert(result_cd.data[2][2] == 117);

    // Test 3: Multiply by a zero matrix (2x3 multiplied by a zero 3x2 matrix)
    let zero: Matrix<3, 2, Field> = Matrix {
        data: [[0, 0], [0, 0], [0, 0]],
    };
    let result_zero = a.mult(zero);

    // Expected: Zero matrix of size 2x2
    assert(result_zero.data[0][0] == 0);
    assert(result_zero.data[0][1] == 0);
    assert(result_zero.data[1][0] == 0);
    assert(result_zero.data[1][1] == 0);

    // Test 4: Multiply a 2x3 matrix by a 3x3 identity matrix
    let a: Matrix<2, 3, Field> = Matrix {
        data: [[1, 2, 3], [4, 5, 6]],
    };
    let identity: Matrix<3, 3, Field> = Matrix {
        data: [[1, 0, 0], [0, 1, 0], [0, 0, 1]],
    };
    let result_identity = a.mult(identity);

    // Expected: Same as `a`
    assert(result_identity.data[0][0] == 1);
    assert(result_identity.data[0][1] == 2);
    assert(result_identity.data[0][2] == 3);
    assert(result_identity.data[1][0] == 4);
    assert(result_identity.data[1][1] == 5);
    assert(result_identity.data[1][2] == 6);
}
