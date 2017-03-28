//
//  SportsNewsViewController.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/23.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportsNewsViewController : UIViewController
@property(nonatomic,strong)UITableView *saiChengTb;
@property(nonatomic,strong)UITableView *jiFenBangTb;
@property(nonatomic,strong)UITableView *sheShouBangTb;
@property(nonatomic,strong)NSMutableArray *dataArray;   //赛程数据源
@property(nonatomic,strong)NSMutableArray *dataArray1;  //积分榜数据源
@property(nonatomic,strong)NSMutableArray *dataArray2;  //射手榜数据源

@property(nonatomic,strong)NSMutableArray *saicheng1Arr;
@property(nonatomic,strong)NSMutableArray *saicheng2Arr;
@property(nonatomic,strong)NSMutableArray *jifenbangArr;
@property(nonatomic,strong)NSMutableArray *sheshoubangArr;

@property(nonatomic,strong)NSArray *headerStrArr;
@property(nonatomic,strong)NSMutableArray *arr;
@end
