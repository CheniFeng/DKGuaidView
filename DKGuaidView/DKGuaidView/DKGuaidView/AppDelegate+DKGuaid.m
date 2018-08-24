//
//  AppDelegate+DKGuaid.m
//  DKGuaidView
//
//  Created by 雪凌 on 2018/8/24.
//  Copyright © 2018年 雪凌. All rights reserved.
//

#import "AppDelegate+DKGuaid.h"
#import <objc/runtime.h>

#import "DKGuaidViewController.h"

const char* kGuaidWindowId = "dkGuaidWindowKey";
NSString * const kLastVersionId = @"dkLastVersionKey";

@implementation AppDelegate (DKGuaid)

#pragma mark- *** Load ***

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 获取当前版本号及上次保存的版本号
        NSString *lastVersion = [[NSUserDefaults standardUserDefaults] stringForKey:kLastVersionId];
        NSString *curVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        
        // 比较两个版本号,判断是否需要展示引导图,如果需要,则将新的启动方法和系统方法交换
        if ([curVersion compare:lastVersion] == NSOrderedDescending) {
            Method originMethod = class_getInstanceMethod(self.class, @selector(application:didFinishLaunchingWithOptions:));
            Method customMethod = class_getInstanceMethod(self.class, @selector(dkGuaid_application:didFinishLaunchingWithOptions:));
            method_exchangeImplementations(originMethod, customMethod);
        }
    });
}

#pragma mark- *** Launching ***

- (BOOL)dkGuaid_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window = [[UIWindow alloc] init];
    window.frame = self.window.screen.bounds;
    window.backgroundColor = [UIColor clearColor];
    window.windowLevel = UIWindowLevelStatusBar + 1;
    self.guaidWindow = window;
    [window makeKeyAndVisible];
    
    DKGuaidViewController *guaidController = [[DKGuaidViewController alloc] init];
    guaidController.imageNames = @[@"guaid_image_1", @"guaid_image_2",
                                  @"guaid_image_3", @"guaid_image_4"];
    
    __weak typeof(self) weakSelf = self;
    guaidController.shouldHiddenBlock = ^{
        
        // 获取当前版本号,并保存
        NSString* curVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        [[NSUserDefaults standardUserDefaults] setObject:curVersion forKey:kLastVersionId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 执行隐藏动画
        [UIView animateWithDuration:1.5 animations:^{
            weakSelf.guaidWindow.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.guaidWindow resignKeyWindow];
            weakSelf.guaidWindow.hidden = YES;
            weakSelf.guaidWindow = nil;
        }];
    };
    
    self.guaidWindow.rootViewController = guaidController;
    
    return [self dkGuaid_application:application didFinishLaunchingWithOptions:launchOptions];
}


#pragma mark- *** Setters And Getters ***

- (UIWindow *)guaidWindow {
    return objc_getAssociatedObject(self, kGuaidWindowId);
}

- (void)setGuaidWindow:(UIWindow *)guaidWindow {
    objc_setAssociatedObject(self, kGuaidWindowId, guaidWindow, OBJC_ASSOCIATION_RETAIN);
}

@end
