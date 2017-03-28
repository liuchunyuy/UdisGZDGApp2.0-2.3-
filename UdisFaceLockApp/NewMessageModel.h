//
//  NewMessageModel.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/9/12.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "JSONModel.h"

@interface NewMessageModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *datetime;
@property(nonatomic,copy) NSString *messageImg;

@end
