#!/bin/sh

cd `dirname $0`
source ./settings.sh

cd ${XCODE_ROOT_DIR}

# SDL2ダウンロード
curl -L -O https://www.libsdl.org/release/SDL2-${SDL2_VERSION}.tar.gz
tar xvzf ./SDL2-${SDL2_VERSION}.tar.gz
rm -f ./SDL2-${SDL2_VERSION}.tar.gz

# SDL_imageダウンロード
curl -L -O https://www.libsdl.org/projects/SDL_image/release/SDL2_image-${SDL2_IMAGE_VERSION}.tar.gz
tar xvzf ./SDL2_image-${SDL2_IMAGE_VERSION}.tar.gz
rm -f ./SDL2_image-${SDL2_IMAGE_VERSION}.tar.gz

# bindbc-sdlクローン
git clone https://github.com/BindBC/bindbc-sdl.git

