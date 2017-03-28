//
//  JiFenModel.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/1/10.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "JSONModel.h"

@interface JiFenModel : JSONModel

@property (nonatomic,assign) NSInteger c1;   // 排名
@property (nonatomic,copy) NSString *c2;   // 球队
@property (nonatomic,copy) NSString *c3;   // 场次
@property (nonatomic,assign) NSInteger c41;  // 胜
@property (nonatomic,assign) NSInteger c42;  // 平
@property (nonatomic,assign) NSInteger c43;  // 负
@property (nonatomic,assign) NSInteger c6;   // 积分
@property (nonatomic,copy) NSString *c2L;  // 链接
@end
