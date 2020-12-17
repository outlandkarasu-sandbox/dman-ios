#!/bin/sh

cd `dirname $0`
source ./settings.sh

LDC_DIR=~/dlang/ldc-${LDC_VERSION}

. ${LDC_DIR}/activate

# druntimeのUniversal Library作成
xcrun -sdk iphoneos lipo -create \
    ${LDC_DIR}/lib-ios-arm64/libdruntime-ldc.a \
    ${LDC_DIR}/lib-ios-x86_64/libdruntime-ldc.a \
    -output ${LIB_DIR}/libdruntime-ldc.a

# phobos2のUniversal Library作成
xcrun -sdk iphoneos lipo -create \
    ${LDC_DIR}/lib-ios-arm64/libphobos2-ldc.a \
    ${LDC_DIR}/lib-ios-x86_64/libphobos2-ldc.a \
    -output ${LIB_DIR}/libphobos2-ldc.a

