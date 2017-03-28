//
//  JiFenTableViewCell.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/1/10.
//  Copyright © 2017年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiFenModel.h"
@interface JiFenTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamLabel;
@property (strong, nonatomic) IBOutlet UILabel *totleLabel;
@property (strong, nonatomic) IBOutlet UILabel *victoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *equalLabel;
@property (strong, nonatomic) IBOutlet UILabel *loseLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

@property (nonatomic,strong) JiFenModel *model;
@end
