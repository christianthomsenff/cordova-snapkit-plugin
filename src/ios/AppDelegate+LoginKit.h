#import "AppDelegate.h"
#import "SCSDKLoginKit/SCSDKLoginKit.h"

@interface AppDelegate(LoginKit)

- (BOOL)application:(UIApplication *)application
        openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

@end
