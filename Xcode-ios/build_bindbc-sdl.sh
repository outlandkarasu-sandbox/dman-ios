#!/bin/sh

cd `dirname $0`/bindbc-sdl

LDC_VERSION=1.24.0
TARGET_PATH=./lib
LIBRARY_BASE_NAME=libBindBC_SDL
LIBRARY_NAME=${LIBRARY_BASE_NAME}.a
LIBRARY_NAME_ARM64=${LIBRARY_BASE_NAME}-arm64.a
LIBRARY_NAME_X86_64=${LIBRARY_BASE_NAME}-x86_64.a
LIBRARY_NAME_IOS=${LIBRARY_BASE_NAME}-ios.a
LIBRARY_DIR=../Libraries
LDC_DIR=~/dlang/ldc-${LDC_VERSION}

. ${LDC_DIR}/activate

# Arm向けにビルド
dub build --arch=arm64-apple-ios --config=static
mv ${TARGET_PATH}/${LIBRARY_NAME} ${LIBRARY_DIR}/${LIBRARY_NAME_ARM64}


# x86_64向け(iOS Simulator)にビルド
dub build --arch=x86_64-apple-ios --config=static
mv ${TARGET_PATH}/${LIBRARY_NAME} ${LIBRARY_DIR}/${LIBRARY_NAME_X86_64}

# Universal libraryにまとめる
xcrun -sdk iphoneos lipo -create \
	${LIBRARY_DIR}/${LIBRARY_NAME_ARM64} \
	${LIBRARY_DIR}/${LIBRARY_NAME_X86_64} \
	-output ${LIBRARY_DIR}/${LIBRARY_NAME_IOS}

