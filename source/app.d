import core.attribute : selector;
import std.exception : basicExceptionCtors;
import std.stdio;
import std.string : fromStringz;
import std.traits : isPointer;

import bindbc.sdl;

/**
NSObjectの宣言
*/
extern(Objective-C)
extern class NSObject
{
    void release() @selector("release");
}

/**
NSDataの宣言
*/
extern(Objective-C)
extern class NSData : NSObject
{
    ulong length() @selector("length");
    void getBytes(void* buffer, ulong length) @selector("getBytes:length:");
}

/**
main.mで定義した画像読み込み関数の宣言
*/
extern(C) NSData getImagePNGRepresentation(const(char)* name, ulong nameLength);

/**
Frames per second.
*/
enum FPS = 60;

/**
SDLエラー時の例外
*/
class SDLException : Exception
{
    mixin basicExceptionCtors;

    /**
    SDL_GetError内容から生成する。

    Params:
        file = ファイル名
        line = 行番号
    Returns:
        SDL_GetError内容から生成したSDLException
    */
    static SDLException fromError(string file = __FILE__, size_t line = __LINE__) nothrow
    {
        return new SDLException(fromStringz(SDL_GetError()).idup, file, line);
    }
}

/**
SDLエラー時に例外をスローする。

Params:
    T = 式の型
    expr = チェック対象の式
    file = ファイル名
    line = 行番号
Throws:
    エラー発生時にSDLExceptionをスローする。
*/
T assumeSDLSuccess(T)(lazy T expr, string file = __FILE__, size_t line = __LINE__) if (is(T == int))
{
    auto result = expr;
    if (result != 0)
    {
        throw SDLException.fromError(file, line);
    }
    return result;
}

/// ditto
T assumeSDLSuccess(T)(lazy T expr, string file = __FILE__, size_t line = __LINE__) if (isPointer!T || is(T == bool))
{
    auto result = expr;
    if (!result)
    {
        throw SDLException.fromError(file, line);
    }
    return result;
}

/**
Dランタイム開始関数の宣言

普通のライブラリとしては公開されていないので、明示的に宣言を行う。
ドキュメントはこちら
https://dlang.org/library/rt/dmain2/_d_run_main.html
*/
alias extern(C) int function(char[][] args) MainFunc;
extern (C) int _d_run_main(int argc, char** argv, MainFunc mainFunc);

/**
D言語側の開始関数

Params:
    argc = コマンドライン引数の数
    argv = コマンドライン引数の配列
Returns:
    終了コード
*/
extern(C) int dmanStartup(int argc, char** argv)
{
    return _d_run_main(argc, argv, &dmanMain);
}

/**
D言語のメイン関数

Params:
    args = コマンドライン引数
Returns:
    終了コード
*/
extern(C) int dmanMain(char[][] args)
{
    // SDL初期化
    assumeSDLSuccess(SDL_Init(SDL_INIT_VIDEO));
    scope(exit) SDL_Quit();

    // SDL_image初期化(PNG使用)
    assumeSDLSuccess(IMG_Init(IMG_INIT_PNG) == IMG_INIT_PNG);
    scope(exit) IMG_Quit();

    writeln("Hello, D iOS SDL World!");

    // ウィンドウとレンダラー生成
    SDL_Window* window;
    SDL_Renderer* renderer;
    assumeSDLSuccess(SDL_CreateWindowAndRenderer(
        320, 480, SDL_WINDOW_FULLSCREEN, &window, &renderer));
    scope(exit)
    {
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
    }

    // 画像をSDLのSurfaceとして読み込む。
    auto imageSurface = ({
        // 画像アセットの読み込み
        auto dmanImage = getImagePNGRepresentation("dman", 4);
        scope(exit) dmanImage.release();

        // 画像のバイトデータを取り出す。
        scope imageBuffer = new void[dmanImage.length];
        dmanImage.getBytes(imageBuffer.ptr, imageBuffer.length);

        // メモリリーダーを初期化
        auto imageReader = assumeSDLSuccess(
            SDL_RWFromMem(imageBuffer.ptr, cast(int) imageBuffer.length));
        scope(exit) SDL_RWclose(imageReader);

        // SDL_imageで読み込み
        return assumeSDLSuccess(IMG_LoadPNG_RW(imageReader));
    })();
    scope(exit) SDL_FreeSurface(imageSurface);

    // テクスチャ生成
    auto texture = assumeSDLSuccess(SDL_CreateTextureFromSurface(renderer, imageSurface));
    scope(exit) SDL_DestroyTexture(texture);

    // 1フレーム当たりのパフォーマンスカウンタ値計算。FPS制御のために使用する。
    immutable performanceFrequency = SDL_GetPerformanceFrequency();
    immutable countPerFrame = performanceFrequency / FPS;

    // メインループ
    mainLoop: for (;;)
    {
        immutable frameStart = SDL_GetPerformanceCounter();

        // イベントがキューにある限り処理を行う。
        for (SDL_Event e; SDL_PollEvent(&e);)
        {
            switch(e.type)
            {
            case SDL_QUIT:
                break mainLoop;
            default:
                break;
            }
        }

        // 画面クリア
        SDL_SetRenderDrawColor(renderer, 0xFF, 0x00, 0x00, 0xFF);
        SDL_RenderClear(renderer);

        // 画像描画
        SDL_RenderCopy(renderer, texture, null, null);
        SDL_RenderPresent(renderer);

        // 次フレームまで待機
        immutable drawDelay = SDL_GetPerformanceCounter() - frameStart;
        if(countPerFrame < drawDelay)
        {
            SDL_Delay(0);
        }
        else
        {
            SDL_Delay(cast(uint)((countPerFrame - drawDelay) * 1000 / performanceFrequency));
        }
    }

    return 0;
}

