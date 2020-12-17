#!/bin/sh

cd `dirname $0`
source ./settings.sh

cd ${DMAN_DIR}

source ${LDC_DIR}/activate

# Arm向けにビルド
dub build --arch=arm64-apple-ios
mv libdman-ios.a ${LIB_DIR}/libdman-ios-arm64.a

# x86_64向け(iOS Simulator)にビルド
dub build --arch=x86_64-apple-ios
mv libdman-ios.a ${LIB_DIR}/libdman-ios-x86_64.a

# Universal Libraryにまとめる
xcrun -sdk iphoneos lipo -create \
    ${LIB_DIR}/libdman-ios-arm64.a \
    ${LIB_DIR}/libdman-ios-x86_64.a \
    -output ${LIB_DIR}/libdman-ios-ios.a

