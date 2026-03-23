#!/bin/bash
# =============================================================================
# Eigen 5.0 MUSA 测试编译脚本 (Build Only)
# =============================================================================

EIGEN_ROOT=$(pwd)
BUILD_DIR="${EIGEN_ROOT}/build"
MCC="/usr/local/musa/bin/mcc"
MUSA_LIB="-lmusart -L/usr/local/musa/lib"
ARCH="--offload-arch=mp_22"
CXX_FLAGS="-mtgpu -std=c++14 -O2 -Wno-invalid-partial-specialization"
DEFINES="-DEIGEN_USE_GPU -DEIGEN_USE_MUSA -DEIGEN_TEST_PART_ALL -DEIGEN_TEST_NO_LONGDOUBLE"
INCLUDES="-I${EIGEN_ROOT} -I${EIGEN_ROOT}/test -I${EIGEN_ROOT}/unsupported -I${EIGEN_ROOT}/unsupported/test"

cd "$EIGEN_ROOT"
mkdir -p $BUILD_DIR

TESTS=(
    "test/gpu_basic"
    "unsupported/test/cxx11_tensor_random_gpu"
    "unsupported/test/cxx11_tensor_argmax_gpu"
    "unsupported/test/cxx11_tensor_reduction_gpu"
    "unsupported/test/cxx11_tensor_scan_gpu"
    "unsupported/test/cxx11_tensor_complex_cwise_ops_gpu"
    "unsupported/test/cxx11_tensor_complex_gpu"
    "unsupported/test/cxx11_tensor_gpu"
    "unsupported/test/cxx11_tensor_cast_float16_gpu"
    "unsupported/test/cxx11_tensor_of_float16_gpu"
    "unsupported/test/cxx11_tensor_of_bfloat16_gpu"
    "unsupported/test/cxx11_tensor_contract_gpu"
    "unsupported/test/cxx11_tensor_device"
)

compile_test() {
    local test_path=$1
    local test_name=$(basename "$test_path")
    local src_file="${EIGEN_ROOT}/${test_path}.cu"
    local out_file="${BUILD_DIR}/${test_name}"

    if [ ! -f "$src_file" ]; then
        echo "❌ 文件不存在: $src_file"
        return 1
    fi

    echo -n "编译 ${test_name}... "

    local extra=""
    # gpu_basic uses complex types (Vector3cf) even though its name doesn't contain "complex"
    if [[ "$test_name" == *"complex"* ]] || [[ "$test_name" == "gpu_basic" ]]; then
        extra=""
    else
        extra="-DEIGEN_TEST_NO_COMPLEX"
    fi

    $MCC "$src_file" -o "$out_file" \
        $INCLUDES \
        $DEFINES \
        $extra \
        $MUSA_LIB \
        $ARCH \
        $CXX_FLAGS \
        2>/tmp/musa5_compile_err.txt

    if [ $? -eq 0 ] && [ -f "$out_file" ]; then
        echo "✅"
        return 0
    else
        echo "❌"
        grep -E "error:" /tmp/musa5_compile_err.txt | head -5
        return 1
    fi
}

echo "========================================"
echo "Eigen 5.0 MUSA 测试编译"
echo "========================================"

pass=0; fail=0

if [ -n "$1" ]; then
    for t in "${TESTS[@]}"; do
        if [[ "$(basename $t)" == "$1" ]]; then
            if compile_test "$t"; then ((++pass)); else ((++fail)); fi
            break
        fi
    done
else
    for t in "${TESTS[@]}"; do
        if compile_test "$t"; then ((++pass)); else ((++fail)); fi
    done
fi

echo ""
echo "========================================"
echo "编译结果: ${pass} 成功, ${fail} 失败"
echo "========================================"
exit $fail
