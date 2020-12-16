// これが大事
#include <SDL/SDL.h>

#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

// 画像ファイルを読み込む。
NSData* getImagePNGRepresentation(const char *name, unsigned long nameLength) {
    @autoreleasepool {
        NSString* imageName = [NSString alloc];
        imageName = [imageName initWithBytes:name length:nameLength encoding:NSUTF8StringEncoding];
        UIImage* image = [UIImage imageNamed:imageName];
        return UIImagePNGRepresentation(image);
    }
}

// D言語の開始関数
int dmanStartup(int argc, char **argv);

int main(int argc, char **argv) {
    return dmanStartup(argc, argv);
}
