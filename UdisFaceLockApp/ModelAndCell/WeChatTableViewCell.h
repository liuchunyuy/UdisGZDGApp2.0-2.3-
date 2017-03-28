//
//  WeChatTableViewCell.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/21.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeChatModel.h"

@interface WeChatTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *firstImg;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *source;

@property (nonatomic,strong) WeChatModel *model;
@end
