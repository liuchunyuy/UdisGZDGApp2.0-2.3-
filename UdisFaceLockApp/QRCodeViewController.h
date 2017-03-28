//
//  QRCodeViewController.h
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
@interface QRCodeViewController : UIViewController{
    AsyncSocket *clientSocket;
}



@end
