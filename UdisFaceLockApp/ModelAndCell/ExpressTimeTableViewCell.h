//
//  ExpressTimeTableViewCell.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/4/7.
//  Copyright © 2017年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressTimeModel.h"
@interface ExpressTimeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *statueLabel;

@property(nonatomic,strong)ExpressTimeModel *model;
@end
