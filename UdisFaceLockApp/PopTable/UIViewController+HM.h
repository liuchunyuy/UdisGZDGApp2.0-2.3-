//
//  UIViewController+HM.h
//  HMSdkDemo
//
//  Created by orvibo on 16/4/15.
//  Copyright © 2016年 orvibo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HM)

- (void)popAlertWithMessage:(NSString *)message;

- (void)showHUD;

- (void)hideHUD;

- (void)addTouchAction;

@end
