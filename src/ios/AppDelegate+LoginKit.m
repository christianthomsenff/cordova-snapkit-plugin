#import "AppDelegate+LoginKit.h"

@implementation AppDelegate (LoginKit)

- (BOOL)application:(UIApplication *)application
        openURL:(NSURL *)url
        options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    if ([SCSDKLoginClient application:application openURL:url options:options]) {
        return YES;    } else {
        return NO;
    }
}
@end