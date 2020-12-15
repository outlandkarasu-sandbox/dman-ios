import std.stdio;

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
	writeln("Edit source/app.d to start your project.");

    return 0;
}

