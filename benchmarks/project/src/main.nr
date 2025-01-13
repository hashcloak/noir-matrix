use dep::matrix_arithmetic::matrix::{dot_product, Matrix, trace};

/// Non-square matrix multiplication

//  90.016 gates
// fn main(a: Matrix<50, 30, Field>, b: Matrix<30, 60, Field>) -> pub Matrix<50, 60, Field> {
//     a.mult(b)
// }

// 1.320.016 gates
// fn main(a: Matrix<100, 120, Field>, b: Matrix<120, 110, Field>) -> pub Matrix<100, 110, Field> {
//     a.mult(b)
// }

/// 50x50 matrices

// 2.516 gates
// Same costs for subtraction and scalar mult
// fn main(a: Matrix<50, 50, Field>, b: Matrix<50, 50, Field>) -> pub Matrix<50, 50, Field> {
//     a + b
// }

// 125.016
// fn main(a: Matrix<50, 50, Field>, b: Matrix<50, 50, Field>) -> pub Matrix<50, 50, Field> {
//     a.mult(b)
// }

/// 100x100 matrices

// 10.016 gates
// Same costs for subtraction and scalar mult
// fn main(a: Matrix<100, 100, Field>, b: Matrix<100, 100, Field>) -> pub Matrix<100, 100, Field> {
//     a + b
// }

// 1.000.016
// fn main(a: Matrix<100, 100, Field>, b: Matrix<100, 100, Field>) -> pub Matrix<100, 100, Field> {
//     a.mult(b)
// }

/// dot_product
// 116
// fn main(u: [Field; 100], v: [Field; 100]) -> pub Field {
//     dot_product(u, v)
// }

/// trace
// 50
fn main(a: Matrix<100, 100, Field>) -> pub Field {
    trace(a)
}
