//
//  SheShouBangTableViewCell.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/1/12.
//  Copyright © 2017年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SheShouBangModel.h"

@interface SheShouBangTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet UILabel *playerLabel;
@property (strong, nonatomic) IBOutlet UILabel *goalLabel;
@property (strong, nonatomic) IBOutlet UILabel *assistLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamLabel;

@property (nonatomic,strong) SheShouBangModel *model;
@end
