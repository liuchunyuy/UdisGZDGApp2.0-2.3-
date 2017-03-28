//
//  LongDistanceBusModel.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/22.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "JSONModel.h"

@interface LongDistanceBusModel : JSONModel

@property (nonatomic,copy) NSString *start;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *price;
@end
