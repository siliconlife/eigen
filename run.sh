#!/bin/bash
# =============================================================================
# Eigen 5.0 MUSA 测试运行脚本 (Run Only)
# =============================================================================

EIGEN_ROOT=$(pwd)
BUILD_DIR="${EIGEN_ROOT}/build"

TESTS=(
    "gpu_basic"
    "cxx11_tensor_random_gpu"
    "cxx11_tensor_argmax_gpu"
    "cxx11_tensor_reduction_gpu"
    "cxx11_tensor_scan_gpu"
    "cxx11_tensor_complex_cwise_ops_gpu"
    "cxx11_tensor_complex_gpu"
    "cxx11_tensor_gpu"
    "cxx11_tensor_cast_float16_gpu"
    "cxx11_tensor_of_float16_gpu"
    "cxx11_tensor_of_bfloat16_gpu"
    "cxx11_tensor_contract_gpu"
    "cxx11_tensor_device"
)

run_test() {
    local test_name=$1
    local test_binary="${BUILD_DIR}/${test_name}"

    if [ ! -f "$test_binary" ]; then
        echo "⚠️  跳过 ${test_name}: 未找到二进制文件"
        return 2
    fi

    echo ""
    echo "========================================"
    echo "运行: ${test_name}"
    echo "========================================"

    # Run test with timeout of 600 seconds
    timeout 600 "$test_binary" 2>&1
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        echo "✅ ${test_name} 通过"
        return 0
    elif [ $exit_code -eq 124 ]; then
        echo "⏱️  ${test_name} 超时 (超过600秒)"
        return 1
    else
        echo "❌ ${test_name} 失败 (exit code: $exit_code)"
        return 1
    fi
}

echo "========================================"
echo "Eigen 5.0 MUSA 测试运行"
echo "========================================"

pass=0
fail=0
skip=0

if [ -n "$1" ]; then
    # Run specific test
    run_test "$1"
    exit_code=$?
    if [ $exit_code -eq 0 ]; then
        pass=1
    elif [ $exit_code -eq 2 ]; then
        skip=1
    else
        fail=1
    fi
else
    # Run all tests
    for t in "${TESTS[@]}"; do
        run_test "$t"
        exit_code=$?
        if [ $exit_code -eq 0 ]; then
            ((pass++))
        elif [ $exit_code -eq 2 ]; then
            ((skip++))
        else
            ((fail++))
        fi
    done
fi

echo ""
echo "========================================"
echo "运行结果: ${pass} 通过, ${fail} 失败, ${skip} 跳过"
echo "========================================"

if [ $fail -eq 0 ]; then
    echo "🎉 所有测试通过!"
    exit 0
else
    echo "⚠️  有测试失败，请检查输出"
    exit 1
fi
