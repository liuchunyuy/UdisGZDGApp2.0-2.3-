//
//  RegisteredController.h
//  YunChat
//
//  Created by yiliu on 15/11/5.
//  Copyright (c) 2015年 mushoom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#import "Config.h"
#import "Utils.h"

//@interface RegisteredController : UIViewController
@interface RegisteredController : UIViewController{
    AsyncSocket *clientSocket;
    
}

@property (copy, nonatomic) UITextField *nameTextField;
@property (copy, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *registeredBtn;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIWindow *window;

//- (IBAction)RegisteredBtn:(id)sender;
- (IBAction)LoginBtn:(id)sender;



@end
