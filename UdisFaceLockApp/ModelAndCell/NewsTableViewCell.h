//
//  NewsTableViewCell.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/20.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "NewsViewController.h"

@interface NewsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *author_name;
@property (strong, nonatomic) IBOutlet UILabel *realtypeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnail_pic_s;


@property(nonatomic,strong) NewsModel *model;
@end
