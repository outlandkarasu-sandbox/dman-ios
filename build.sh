#!/bin/sh

cd `dirname $0`

LDC_VERSION=1.24.0
LIBRARY_BASE_NAME=libdman-ios
LIBRARY_NAME=${LIBRARY_BASE_NAME}.a
LIBRARY_NAME_ARM64=${LIBRARY_BASE_NAME}-arm64.a
LIBRARY_NAME_X86_64=${LIBRARY_BASE_NAME}-x86_64.a
LIBRARY_NAME_IOS=${LIBRARY_BASE_NAME}-ios.a
LIBRARY_DIR=./Xcode-ios/Libraries
LDC_DIR=~/dlang/ldc-${LDC_VERSION}

. ${LDC_DIR}/activate

mkdir -p ./Xcode-ios/Libraries

# ランタイムライブラリのUniversal Libraryを生成する
xcrun -sdk iphoneos lipo -create \
        ${LDC_DIR}/lib-ios-arm64/libdruntime-ldc.a \
        ${LDC_DIR}/lib-ios-x86_64/libdruntime-ldc.a \
	-output ${LIBRARY_DIR}/libdruntime-ldc.a
xcrun -sdk iphoneos lipo -create \
        ${LDC_DIR}/lib-ios-arm64/libphobos2-ldc.a \
        ${LDC_DIR}/lib-ios-x86_64/libphobos2-ldc.a \
	-output ${LIBRARY_DIR}/libphobos2-ldc.a

# Arm向けにビルド
dub build --arch=arm64-apple-ios
mv ${LIBRARY_NAME} ${LIBRARY_DIR}/${LIBRARY_NAME_ARM64}


# x86_64向け(iOS Simulator)にビルド
dub build --arch=x86_64-apple-ios
mv ${LIBRARY_NAME} ${LIBRARY_DIR}/${LIBRARY_NAME_X86_64}

# Universal libraryにまとめる
xcrun -sdk iphoneos lipo -create \
	${LIBRARY_DIR}/${LIBRARY_NAME_ARM64} \
	${LIBRARY_DIR}/${LIBRARY_NAME_X86_64} \
	-output ${LIBRARY_DIR}/${LIBRARY_NAME_IOS}

