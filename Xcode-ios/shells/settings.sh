#!/bin/sh

cd `dirname $0`/../

export XCODE_IOS_ROOT=`pwd`
export LIB_DIR=${XCODE_IOS_ROOT}/Libraries

# SDL2設定
export SDL2_VERSION=2.0.12
export SDL2_DIR=${XCODE_IOS_ROOT}/SDL2-${SDL2_VERSION}
export SDL2_INCLUDE_DIR=${XCODE_IOS_ROOT}/SDL/include

# SDL2_image設定
export SDL2_IMAGE_VERSION=2.0.5
export SDL2_IMAGE_DIR=${XCODE_IOS_ROOT}/SDL2_image-${SDL2_IMAGE_VERSION}

# bindbc-sdl設定
export LDC_VERSION=1.24.0
export BINDBC_SDL_DIR=${XCODE_IOS_ROOT}/bindbc-sdl

