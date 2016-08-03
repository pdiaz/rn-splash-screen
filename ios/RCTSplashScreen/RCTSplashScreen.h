#import "RCTBridgeModule.h"
#import "RCTRootView.h"

@interface RCTSplashScreen : NSObject <RCTBridgeModule>

+ (void)show:(RCTRootView *)v;
+ (void)show:(RCTRootView *)v image:(UIImage*)image;

@end
