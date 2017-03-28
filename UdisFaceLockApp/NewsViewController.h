//
//  NewsViewController.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/20.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController
@property(nonatomic,strong)UITableView *tb;

@property(nonatomic,readonly)NSMutableArray *dataArray;
@end
