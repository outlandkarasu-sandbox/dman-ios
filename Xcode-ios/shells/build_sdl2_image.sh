#!/bin/sh

source ./settings.sh
cd ${SDL2_IMAGE_DIR}

# iPhone実機向け
xcodebuild \
    -project ${SDL2_IMAGE_DIR}/Xcode-iOS/SDL_image.xcodeproj \
    -scheme libSDL_image-iOS \
    -sdk iphoneos \
    clean build \
    CONFIGURATION_BUILD_DIR=${LIB_DIR} \
    ARCHS=arm64 \
    ONLY_ACTIVE_ARCH=NO
mv ${LIB_DIR}/libSDL2_image.a ${LIB_DIR}/libSDL2_image-arm64.a

# iOSシミュレーター向け
xcodebuild \
    -project ${SDL2_IMAGE_DIR}/Xcode-iOS/SDL_image.xcodeproj \
    -scheme libSDL_image-iOS \
    -sdk iphonesimulator \
    clean build \
    CONFIGURATION_BUILD_DIR=${LIB_DIR} \
    ARCHS=x86_64 \
    ONLY_ACTIVE_ARCH=NO
mv ${LIB_DIR}/libSDL2_image.a ${LIB_DIR}/libSDL2_image-x86_64.a

# Universal Library作成
xcrun -sdk iphoneos lipo -create \
        ${LIB_DIR}/libSDL2_image-arm64.a \
        ${LIB_DIR}/libSDL2_image-x86_64.a \
	-output ${LIB_DIR}/libSDL2_image-ios.a

