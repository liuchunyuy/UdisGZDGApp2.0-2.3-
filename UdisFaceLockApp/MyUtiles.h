//
//  MyUtiles.h
//  LimitFree
//
//  Created by 共享 on 16/4/5.
//  Copyright (c) 2016年 shishu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MyUtiles : NSObject

//创建label
+ (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment color:(UIColor *)fontColor text:(NSString *)text;

//创建btn
+ (UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title normalBgImg:(NSString *)normaoBgImgName highlightedBgImg:(NSString *)highlightedBgImgName target:(id)target action:(SEL)action;


//类型名字转换成中文
+ (NSString *)transferCateName:(NSString *)name;

//创建textField
+(UITextField *)createTextField:(CGRect)frame placeholder:(NSString *)placeholder alignment:(UIControlContentVerticalAlignment)alignment color:(UIColor *)color keyboardType:(UIKeyboardType)keyboardType viewMode:(UITextFieldViewMode)viewMode secureTextEntry:(BOOL)secureTextEntry;

//创建tableView
+(UITableView*)createTableView:(CGRect)frame tableViewStyle:(UITableViewStyle)tableViewStyle backgroundColor:(UIColor*)backgroundColor separatorColor:(UIColor*)separatorColor separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle showsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator showsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator;

@end
