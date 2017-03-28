//
//  MyUtiles.m
//  LimitFree
//
//  Created by 共享 on 16/4/5.
//  Copyright (c) 2016年 shishu. All rights reserved.
//

#import "MyUtiles.h"

@implementation MyUtiles

+ (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment color:(UIColor *)fontColor text:(NSString *)text;
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = font;
    label.textAlignment = textAlignment;
    label.textColor = fontColor;
    label.text = text;
    return label;
}

+ (UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title normalBgImg:(NSString *)normaoBgImgName highlightedBgImg:(NSString *)highlightedBgImgName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:normaoBgImgName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highlightedBgImgName] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn.imageView setContentMode:UIViewContentModeScaleToFill];
    return btn;
}

+(UITextField *)createTextField:(CGRect)frame placeholder:(NSString *)placeholder alignment:(UIControlContentVerticalAlignment)alignment color:(UIColor *)color keyboardType:(UIKeyboardType)keyboardType viewMode:(UITextFieldViewMode)viewMode secureTextEntry:(BOOL)secureTextEntry{
    
    UITextField *textField = [[UITextField alloc]init];
    textField.frame = frame;
    //_passWord.borderStyle = UITextBorderStyleRoundedRect;
    textField.contentVerticalAlignment = alignment;
    textField.placeholder = placeholder;
    [textField setFont:[UIFont boldSystemFontOfSize:14]];
    textField.backgroundColor = color;
    textField.keyboardType = keyboardType;
    textField.clearButtonMode = viewMode;
    textField.secureTextEntry = secureTextEntry;
    return textField;
}

+(UILabel*)cutLabelPosition:(UIRectCorner)corner cornerRadii:(CGSize)size{
    
    UILabel *label = [[UILabel alloc]init];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds byRoundingCorners:corner cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = label.bounds;
    maskLayer.path = maskPath.CGPath;
    label.layer.mask = maskLayer;

    return label;
}

+(UITableView*)createTableView:(CGRect)frame tableViewStyle:(UITableViewStyle)tableViewStyle backgroundColor:(UIColor*)backgroundColor separatorColor:(UIColor*)separatorColor separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle showsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator showsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator{

    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:tableViewStyle];
    tableView.frame = frame;
    //tableView.tableViewStyle = tableViewStyle;
    tableView.backgroundColor = backgroundColor;
    tableView.separatorColor = separatorColor;
    tableView.separatorStyle = separatorStyle;
    tableView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    tableView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    return tableView;
}

//将分类的英文改成中文
+ (NSString *)transferCateName:(NSString *)name
{
    
    if ([name isEqualToString:@"Business"]) {
        return @"商业";
    }else if ([name isEqualToString:@"Weather"]) {
        return @"天气";
    }else if ([name isEqualToString:@"Tool"]) {
        return @"工具";
    }else if ([name isEqualToString:@"Travel"]) {
        return @"旅行";
    }else if ([name isEqualToString:@"Sports"]) {
        return @"体育";
    }else if ([name isEqualToString:@"Social"]) {
        return @"社交";
    }else if ([name isEqualToString:@"Refer"]) {
        return @"参考";
    }else if ([name isEqualToString:@"Ability"]) {
        return @"效率";
    }else if ([name isEqualToString:@"Photography"]) {
        return @"摄影";
    }else if ([name isEqualToString:@"News"]) {
        return @"新闻";
    }else if ([name isEqualToString:@"Gps"]) {
        return @"导航";
    }else if ([name isEqualToString:@"Music"]) {
        return @"音乐";
    }else if ([name isEqualToString:@"Life"]) {
        return @"生活";
    }else if ([name isEqualToString:@"Health"]) {
        return @"健康";
    }else if ([name isEqualToString:@"Finance"]) {
        return @"财务";
    }else if ([name isEqualToString:@"Pastime"]) {
        return @"娱乐";
    }else if ([name isEqualToString:@"Education"]) {
        return @"教育";
    }else if ([name isEqualToString:@"Book"]) {
        return @"书籍";
    }else if ([name isEqualToString:@"Medical"]) {
        return @"医疗";
    }else if ([name isEqualToString:@"Catalogs"]) {
        return @"商品指南";
    }else if ([name isEqualToString:@"FoodDrink"]) {
        return @"美食";
    }else if ([name isEqualToString:@"Game"]) {
        return @"游戏";
    }else if([name isEqualToString:@"All"]){
        return @"全部";
    }
    
    return nil;
}

@end
