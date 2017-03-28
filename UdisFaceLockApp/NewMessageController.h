//
//  NewMessageController.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/8/9.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMessageController : UIViewController

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITableView *tb;
//@property(nonatomic,assign)RequestType type;
@property(nonatomic,readonly)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *messagesArr;
@end
