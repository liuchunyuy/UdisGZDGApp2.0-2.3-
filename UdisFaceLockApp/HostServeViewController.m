//
//  HostServeViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/2.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "HostServeViewController.h"
#import "MyUtiles.h"
#import "ExpressViewController.h"
#import "TravelViewController.h"
#import "InsuranceViewController.h"
#import "BankViewController.h"
#import "FastFoodViewController.h"
#import "OtherViewController.h"

#define VIEW_HEIGTH self.view.frame.size.height
#define VIEW_WEIGHT self.view.frame.size.width

@interface HostServeViewController ()

@end

@implementation HostServeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"便民热线";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.extendedLayoutIncludesOpaqueBars = YES;// 延伸导航栏至（0.0
    
    [self createView];
}

-(void)createView{

    // 图片 516*175
    NSArray *titleArr = @[@"快递",@"银行",@"快餐",@"旅游",@"保险",@"其他"];
    NSArray *picArr = @[@"TelNumPic_1@3x",@"TelNumPic_2@3x",@"TelNumPic_3@3x",@"TelNumPic_4@3x",@"TelNumPic_5@3x",@"TelNumPic_6@3x"];
    for (int i = 0; i < 6; i++) {
        CGFloat n = 20+(i%2) * (VIEW_WEIGHT-35)/2;
        CGFloat m = 80 + (i/2)*((((VIEW_HEIGTH-45)/2)*175/516/2)+10);
        UIButton *btn = [MyUtiles createBtnWithFrame:CGRectMake(n, m, (VIEW_WEIGHT-45)/2, ((VIEW_HEIGTH-45)/2)*175/516/2) title:titleArr[i] normalBgImg:picArr[i] highlightedBgImg:nil target:self action:@selector(buttonSix:)];
        btn.tag = i+1000;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
}

-(void)buttonSix:(UIButton *)btn{
    
    NSInteger num = btn.tag - 1000;
    
    if (num == 0) {
        NSLog(@"快递");
        self.hidesBottomBarWhenPushed = YES;
        ExpressViewController *expressVc = [[ExpressViewController alloc]init];
        [self.navigationController pushViewController:expressVc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if(num == 1){
        NSLog(@"银行");
        self.hidesBottomBarWhenPushed = YES;
        BankViewController *bankVc = [[BankViewController alloc]init];
        [self.navigationController pushViewController:bankVc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (num == 2){
        NSLog(@"快餐");
        self.hidesBottomBarWhenPushed = YES;
        FastFoodViewController *fastFoodVc = [[FastFoodViewController alloc]init];
        [self.navigationController pushViewController:fastFoodVc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (num == 3){
        NSLog(@"旅游");
        self.hidesBottomBarWhenPushed = YES;
        TravelViewController *travelVc = [[TravelViewController alloc]init];
        [self.navigationController pushViewController:travelVc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (num == 4){
        NSLog(@"保险");
        self.hidesBottomBarWhenPushed = YES;
        InsuranceViewController *insuranceVc = [[InsuranceViewController alloc]init];
        [self.navigationController pushViewController:insuranceVc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if (num == 5){
        NSLog(@"其他");
        self.hidesBottomBarWhenPushed = YES;
        OtherViewController *otherVc = [[OtherViewController alloc]init];
        [self.navigationController pushViewController:otherVc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}

#pragma end Delegate

- (void)timerFireMethod:(NSTimer*)theTimer { //弹出框
    
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
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
