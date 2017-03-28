//
//  LongDistanceBusViewController.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/22.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LongDistanceBusViewController : UIViewController

@property (copy, nonatomic) UITextField *startStationTextField;
@property (copy, nonatomic) UITextField *arriveStationTextField;
@property(nonatomic,strong)UITableView *tb;
@property(nonatomic,readonly)NSMutableArray *dataArray;
@end
