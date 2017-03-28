//
//  WeChatModel.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/21.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "JSONModel.h"

@interface WeChatModel : JSONModel

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *firstImg;

@property (nonatomic,copy) NSString *url;
@end
