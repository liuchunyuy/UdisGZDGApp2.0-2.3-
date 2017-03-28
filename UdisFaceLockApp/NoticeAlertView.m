//
//  NoticeAlertView.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/1/23.
//  Copyright © 2017年 chen. All rights reserved.
//

//http://www.cnblogs.com/xiaobaizhu/archive/2012/11/23/UIAlertView.html

#import "NoticeAlertView.h"

@implementation NoticeAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews{//这个是重点！！重新定义UIAlertView中的各种控件，包括UILabel，UIButton等
    for (UIView *v in self.subviews) {//遍历UIAlertView中的所有控件（UIView），再将它们重新设置
        if ([v isKindOfClass:NSClassFromString(@"UIAlertButton")]) {//设置Button
            UIButton *button = (UIButton *)v;
           // UIImage *image = nil;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
           // [button setBackgroundImage:image forState:UIControlStateNormal];
            if (button.tag == 0){
                button.center = CGPointMake(0, self.bounds.size.height-30);
            }else if(button.tag == 1){
                button.center = CGPointMake(self.bounds.size.width/3, self.bounds.size.height-30);
            }else{
                button.center = CGPointMake(2*(self.bounds.size.width/3), self.bounds.size.height-30);
                
            }
            //[button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}


- (void)show
{
    [super show];
    //self.bounds = CGRectMake(0, 100, 320, 300);//更改整个UIAlertView的框架
}

@end
