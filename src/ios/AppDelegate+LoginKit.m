#import "AppDelegate+LoginKit.h"

@implementation AppDelegate (LoginKit)

- (BOOL)application:(UIApplication *)application
        openURL:(NSURL *)url
        options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    
    BOOL result = [SCSDKLoginClient application:application openURL:url options:options];

    if(result) {
        return YES;
    } else {
        return NO;
    }
}
@end
