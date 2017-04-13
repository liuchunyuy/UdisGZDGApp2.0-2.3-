//
//  AppDelegate.m
//  NewsFourApp
//
//  Created by chen on 14/8/8.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "AppDelegate.h"
#import "MainAppViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
//#import "RegisteredController.h"
#import "ViewController.h"   //启动页

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"


#define QQApp_ID @"1106094446"      //  16进制  41EDA96E
#define QQApp_Key @"sNFxBOKyGlZFvnKZ"

#define Wechat_ID @"wxa57f86d18d296afa"
#define Wechat_Secret @"7f145a189b704a96e6ac4fd917de8491"

#define shareSDK_App_Key @"1ce1c48acdb1c"
#define shareSDK_App_Secret @"58ba5bc30e258c742edcd0688d703535"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[JSPatch startWithAppKey:@"717e9d60336ca60e"];
   // [JSPatch sync];
    // 启动图片延时: 1秒
    //[NSThread sleepForTimeInterval:1];
    
    [ShareSDK registerApp:@"1ce1c48acdb1c"
     
          activePlatforms:@[@(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeQQFriend),]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformSubTypeWechatSession:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:Wechat_ID
                                       appSecret:Wechat_Secret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQApp_ID
                                      appKey:QQApp_Key
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor]; //.............
    self.window.rootViewController = [[ViewController alloc]init];
    [self.window makeKeyAndVisible];
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
