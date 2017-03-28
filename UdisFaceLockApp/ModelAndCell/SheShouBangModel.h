//
//  SheShouBangModel.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/1/12.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "JSONModel.h"

@interface SheShouBangModel : JSONModel

@property (nonatomic,assign) NSInteger c1;   // 排名
@property (nonatomic,copy) NSString *c2;   // 球员
@property (nonatomic,copy) NSString *c3;   // 场队
@property (nonatomic,assign) NSInteger c4;  // 进球
@property (nonatomic,assign) NSInteger c5;  // 助攻
@property (nonatomic,copy) NSString *c2L;  // 球员链接
@end
