//
//  SprottsTableViewCell.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/1/5.
//  Copyright © 2017年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoportsModel.h"
@interface SprottsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *C2C3Label;
@property (strong, nonatomic) IBOutlet UIButton *c4T1Button;
@property (strong, nonatomic) IBOutlet UIImageView *c4T1URLImage;
@property (strong, nonatomic) IBOutlet UILabel *c4RLabel;
@property (strong, nonatomic) IBOutlet UIImageView *c4T2URLImage;
@property (strong, nonatomic) IBOutlet UIButton *c4T2Button;
@property (strong, nonatomic) IBOutlet UILabel *C3Label;

@property (nonatomic,strong) SoportsModel *model;
@end
