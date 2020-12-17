#!/bin/sh

cd `dirname $0`
source ./settings.sh

TARGET_DIR=${BINDBC_SDL_DIR}/lib
LIB_BASE_NAME=libBindBC_SDL
LIB_NAME=${LIB_BASE_NAME}.a
LIB_NAME_ARM64=${LIB_BASE_NAME}-arm64.a
LIB_NAME_X86_64=${LIB_BASE_NAME}-x86_64.a
LIB_NAME_IOS=${LIB_BASE_NAME}-ios.a

source ${LDC_DIR}/activate

cd ${BINDBC_SDL_DIR}

# Arm向けにビルド
dub build --arch=arm64-apple-ios --config=static
mv ${TARGET_DIR}/${LIB_NAME} ${LIB_DIR}/${LIB_NAME_ARM64}

# x86_64向け(iOS Simulator)にビルド
dub build --arch=x86_64-apple-ios --config=static
mv ${TARGET_DIR}/${LIB_NAME} ${LIB_DIR}/${LIB_NAME_X86_64}

# Universal libraryにまとめる
xcrun -sdk iphoneos lipo -create \
	${LIB_DIR}/${LIB_NAME_ARM64} \
	${LIB_DIR}/${LIB_NAME_X86_64} \
	-output ${LIB_DIR}/${LIB_NAME_IOS}

