//
//  UIViewController+HM.m
//  HMSdkDemo
//
//  Created by orvibo on 16/4/15.
//  Copyright © 2016年 orvibo. All rights reserved.
//

#import "UIViewController+HM.h"
#import "MBProgressHUD.h"

#define IOS7 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
#define IOS8 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
#define IOS9 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 9.0)
@implementation UIViewController (HM)

- (void)popAlertWithMessage:(NSString *)message
{
    if (IOS8) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertC addAction:cancelAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }else {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertV show];
    }
}

- (void)showHUD
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)addTouchAction
{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchView)]];
}

- (void)touchView
{
    [self.view endEditing:YES];
}

@end
