//
//  LongDistanceBusTableViewCell.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/22.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LongDistanceBusModel.h"

@interface LongDistanceBusTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *busStation;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *price;

@property (nonatomic,strong) LongDistanceBusModel *model;
@end
