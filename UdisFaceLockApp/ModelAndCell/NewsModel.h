//
//  NewsModel.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/20.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "JSONModel.h"

@interface NewsModel : JSONModel

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *author_name;
@property (nonatomic,copy) NSString *realtype;
@property (nonatomic,copy) NSString *thumbnail_pic_s;
//@property (nonatomic,copy) NSString *uniquekey;
@property (nonatomic,copy) NSString *url;
@end
