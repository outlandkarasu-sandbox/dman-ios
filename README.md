# dman-ios

D言語によるiOSサンプルアプリケーション

本プロジェクトは、Zennで公開している本[「D言語でiOS+SDL2開発を行う」](https://zenn.dev/outlandkarasu/books/2b9cf8042f1604)のサンプルコードです。

## 前提環境

* macOS Big Sur version 11.1
* Xcode Version 12.3
* iPhone 11 Pro (iOS 14.2)

## 事前準備

* [GnuPG](https://gnupg.org/download/)のインストールが必要です。
* Xcodeのコマンドラインツールのインストールが必要です。
* インストールスクリプトを使用してLDCをインストールしている想定です。
    * [install.sh](https://dlang.org/install.html)
    * 詳しい使用法については[こちら](https://zenn.dev/outlandkarasu/books/2b9cf8042f1604/viewer/b50613#ldc%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)

## ビルド方法

[shells](./Xcode-ios/shells)ディレクトリに必要ライブラリのダウンロードおよびビルド用スクリプトが用意されています。
各ライブラリのライセンスをご確認のうえ、ダウンロードを行ってライブラリを使用してください。

ビルド手順は以下の通りです。

1. `./Xcode-ios/shells`ディレクトリに移動
1. `downloads.sh`を実行
1. `build_druntime.sh`を実行
1. `build_dman.sh`を実行
1. `build_sdl2.sh`を実行
1. `build_sdl2_image.sh`を実行
1. Xcodeで`./Xcode-ios/dman-ios/dman-ios`プロジェクトを開く
1. iOSシミュレーターで起動する。
1. 実機で実行する場合、チーム設定を行った上で、実機を接続して実行する。

## ライセンス

* 本ソースコードの[ライセンス](./LICENSE_1_0.txt)
* 本ソースコードは以下のライブラリを利用しています。
    * [SDL2](https://www.libsdl.org/)
        * [ライセンス](https://www.libsdl.org/license.php)
    * [SDL_image](https://www.libsdl.org/projects/SDL_image/)
        * [ライセンス](http://hg.libsdl.org/SDL_image/file/4f8f87781a5a/COPYING.txt)

