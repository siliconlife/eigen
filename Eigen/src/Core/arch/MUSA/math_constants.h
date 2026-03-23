// This file is part of Eigen, a lightweight C++ template library
// for linear algebra.
//
// MUSA math constants - analogous to HIP hcc/math_constants.h
// Copyright (C) 2024 Moore Threads Technology Co., Ltd.
//
// This Source Code Form is subject to the terms of the Mozilla
// Public License v. 2.0.

#ifndef EIGEN_MATH_CONSTANTS_MUSA_H
#define EIGEN_MATH_CONSTANTS_MUSA_H

// Use MUSA's built-in math constants header if available,
// otherwise fall back to C++ standard library values
#if defined(EIGEN_MUSA_ARCH)
#include <math_constants.h>
#endif

#ifndef MUSART_INF_F
#define MUSART_INF_F  __builtin_inff()
#endif
#ifndef MUSART_NAN_F
#define MUSART_NAN_F  __builtin_nanf("")
#endif
#ifndef MUSART_MAX_NORMAL_F
#include <cfloat>
#define MUSART_MAX_NORMAL_F  FLT_MAX
#endif
#ifndef MUSART_INF
#define MUSART_INF  __builtin_inf()
#endif
#ifndef MUSART_NAN
#define MUSART_NAN  __builtin_nan("")
#endif

#endif  // EIGEN_MATH_CONSTANTS_MUSA_H
