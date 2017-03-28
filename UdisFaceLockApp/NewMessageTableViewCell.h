//
//  NewMessageTableViewCell.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/9/12.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMessageModel.h"
#import "NewMessageController.h"
@interface NewMessageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *datetimeLabel;

@property (nonatomic,strong) NewMessageModel *model;
@end
