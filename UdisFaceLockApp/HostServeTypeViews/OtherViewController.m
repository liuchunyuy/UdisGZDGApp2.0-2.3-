//
//  OtherViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/5.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "OtherViewController.h"
#import "MyUtiles.h"

#define VIEW_HEIGTH self.view.frame.size.height
#define VIEW_WEIGHT self.view.frame.size.width
@interface OtherViewController ()

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"其他";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.extendedLayoutIncludesOpaqueBars = YES;// 延伸导航栏至（0.0
    
    [self createView];

}

-(void)createView{

    UILabel *label = [MyUtiles createLabelWithFrame:CGRectMake(0, VIEW_HEIGTH/2, VIEW_WEIGHT, 60) font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter color:[UIColor lightGrayColor] text:@"(*>.<*)\n暂无其他"];
    label.numberOfLines = 0;
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
