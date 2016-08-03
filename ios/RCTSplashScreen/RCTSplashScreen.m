#import "RCTSplashScreen.h"

static RCTRootView *rootView = nil;

@interface RCTSplashScreen()

@end

@implementation RCTSplashScreen

RCT_EXPORT_MODULE(SplashScreen)


+ (void)show:(RCTRootView *)v {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSString *sizeSuffix = [NSString stringWithFormat:@"-%dh", (int)fmax(screenSize.width, screenSize.height)];
    NSInteger scale = (NSInteger)[UIScreen mainScreen].scale;
    NSString *scaleSuffix = @"";
    if ([UIScreen mainScreen].scale > 1.0) {
        scaleSuffix = [NSString stringWithFormat:@"@%dx", (int)scale];
    }
    
    BOOL isLandscape = (screenSize.height < screenSize.width);
    NSString *orientationSuffix = isLandscape? @"-Landscape" : @"-Portrait";
    NSString *idiomSuffix = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? @"~ipad" : @"";
    
    UIImage *splashImage = nil;
    
    //  Default-800-Landscape-736h@3x.png
    //  Default-800-Portrait-736h@3x.png
    splashImage = [UIImage imageNamed:[NSString stringWithFormat:@"Default-800%@%@%@%@", orientationSuffix, sizeSuffix, scaleSuffix, idiomSuffix]];
    
    
    if (!splashImage) {
        //  Default-800-667h@2x.png
        splashImage = [UIImage imageNamed:[NSString stringWithFormat:@"Default-800%@%@%@", sizeSuffix, scaleSuffix, idiomSuffix]];
    }
    
    if (!splashImage) {
        //  Default-700-Landscape@2x~ipad.png
        //  Default-700-Landscape~ipad.png
        //  Default-700-Portrait@2x~ipad.png
        //  Default-700-Portrait~ipad.png
        splashImage = [UIImage imageNamed:[NSString stringWithFormat:@"Default-700%@%@%@", orientationSuffix, scaleSuffix, idiomSuffix]];
    }
    
    if (!splashImage) {
        //  Default-700-568h@2x.png
        splashImage = [UIImage imageNamed:[NSString stringWithFormat:@"Default-700%@%@%@", sizeSuffix, scaleSuffix, idiomSuffix]];
    }
    
    if (!splashImage) {
        //  Default-700@2x.png
        splashImage = [UIImage imageNamed:[NSString stringWithFormat:@"Default-700%@%@", scaleSuffix, idiomSuffix]];
    }
    
    if (!splashImage) {
        splashImage = [UIImage imageNamed:[NSString stringWithFormat:@"Default-700"]];
    }
    
    if (!splashImage) {
        splashImage = [UIImage imageNamed:[NSString stringWithFormat:@"Default"]];
    }

    if (!splashImage) {
        splashImage = [UIImage imageNamed:@"splash"];
    }

    [RCTSplashScreen show:v image:splashImage];
}


+ (void)show:(RCTRootView *)v image:(UIImage*)image {
    rootView = v;
    rootView.loadingViewFadeDelay = 0.1;
    rootView.loadingViewFadeDuration = 0.1;
    UIImageView *view = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.image = image;
    
    [[NSNotificationCenter defaultCenter] removeObserver:rootView  name:RCTContentDidAppearNotification object:rootView];
    
    [rootView setLoadingView:view];
}


RCT_EXPORT_METHOD(hide) {
    if (!rootView) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(rootView.loadingViewFadeDuration * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   ^{
                       [UIView transitionWithView: rootView
                                         duration:rootView.loadingViewFadeDelay
                                          options:UIViewAnimationOptionTransitionCrossDissolve
                                       animations:^{
                                           rootView.loadingView.hidden = YES;
                                       } completion:^(__unused BOOL finished) {
                                           [rootView.loadingView removeFromSuperview];
                                       }];
                   });
}

@end
