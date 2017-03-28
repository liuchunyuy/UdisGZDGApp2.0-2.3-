

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#import "DbUtil.h"
#import "ServerInfo.h"
#import "Utils.h"
#import "Config.h"
#import "CNPPopupController.h"

//弹出窗口
#import "PopoverView.h"

@interface MainAppViewController : UIViewController{
    AsyncSocket *clientSocket;
    //NSString *noticeMessages;
}

@property(nonatomic,copy)NSArray *noticeMessages;  //登录时获得的公告消息数组

@end
