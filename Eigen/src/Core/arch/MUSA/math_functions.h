// This file is part of Eigen, a lightweight C++ template library
// for linear algebra.
//
// MUSA device math function stubs for functions missing from the MUSA toolchain.
// The MUSA SDK declares logb(float) in its headers but doesn't provide an
// implementation. This header provides the missing definitions.

#ifndef EIGEN_MUSA_MATH_FUNCTIONS_H
#define EIGEN_MUSA_MATH_FUNCTIONS_H

// Only define these in device compilation mode
#if defined(__MUSA_ARCH__)

// logb(float) is declared in MUSA's __clang_musa_builtin_forward_declares.h
// but no implementation is provided in __clang_musa_additional_math.h.
// We provide the implementation here.
__device__ inline float logb(float x) { return logbf(x); }
__device__ inline int ilogb(float x) { return ilogbf(x); }

#endif  // __MUSA_ARCH__

#endif  // EIGEN_MUSA_MATH_FUNCTIONS_H
