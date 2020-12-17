#!/bin/sh

cd `dirname $0`
source ./settings.sh

# iPhone実機向け
xcodebuild \
    -project ${SDL2_DIR}/Xcode-iOS/SDL/SDL.xcodeproj \
    -scheme libSDL-iOS \
    -sdk iphoneos \
    clean build \
    CONFIGURATION_BUILD_DIR=${LIB_DIR} \
    ARCHS=arm64 \
    ONLY_ACTIVE_ARCH=NO
mv ${LIB_DIR}/libSDL2.a ${LIB_DIR}/libSDL2-arm64.a

# iOSシミュレーター向け
xcodebuild \
    -project ${SDL2_DIR}/Xcode-iOS/SDL/SDL.xcodeproj \
    -scheme libSDL-iOS \
    -sdk iphonesimulator \
    clean build \
    CONFIGURATION_BUILD_DIR=${LIB_DIR} \
    ARCHS=x86_64 \
    ONLY_ACTIVE_ARCH=NO
mv ${LIB_DIR}/libSDL2.a ${LIB_DIR}/libSDL2-x86_64.a

# Universal Library作成
xcrun -sdk iphoneos lipo -create \
        ${LIB_DIR}/libSDL2-arm64.a \
        ${LIB_DIR}/libSDL2-x86_64.a \
	-output ${LIB_DIR}/libSDL2-ios.a

# インクルードファイルのコピー
mkdir -p ${SDL2_INCLUDE_DIR}
cp -r ${SDL2_DIR}/include/* ${SDL2_INCLUDE_DIR}/

