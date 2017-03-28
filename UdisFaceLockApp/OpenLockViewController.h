//
//  OpenLockViewController.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/9/7.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#import "DbUtil.h"
#import "ServerInfo.h"
#import "Utils.h"
#import "Config.h"
#import "CNPPopupController.h"
#import "PopoverView.h"
@interface OpenLockViewController : UIViewController{
    
    AsyncSocket *clientSocket;
    
}
////定义开锁图片
//@property (nonatomic,retain) UIImageView *lockImageView;
//@property (nonatomic,retain) UIImageView *lockImageView1;
//@property (nonatomic,retain) UIImageView *headImageView;


//用户图片
@property (nonatomic,retain) UIImageView *userImageView;
//@property (nonatomic,retain) UIImage *userImageView;


@end
