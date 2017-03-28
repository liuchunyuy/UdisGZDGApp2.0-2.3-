//
//  SportsNewsDetailViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/1/9.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "SportsNewsDetailViewController.h"

#import "MBProgressHUD.h"

@interface SportsNewsDetailViewController ()

@end

@implementation SportsNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSString * string=@"2011-11-29";
    _c52Link=[_c52Link stringByReplacingOccurrencesOfString:@"http"withString:@"https"];
    //NSLog(@"replaceStr=%@",string);
    NSLog(@"c52Link is %@",_c52Link);
    
    self.navigationItem.title = @"全场战报";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self loadData];
}

-(void)loadData{
    
    //判断字符是否包含某字符串；
    NSString *string = @"shtml";
    
    //字条串是否包含有某字符串
    if ([_c52Link containsString:string]) {
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height)];
        [MBProgressHUD showHUDAddedTo:webView animated:YES];
        webView.scalesPageToFit = YES;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_c52Link]]];
        [self.view addSubview:webView];
        [MBProgressHUD hideHUDForView:webView animated:YES];
    } else {
        [self showAlert:@"没有信息"];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.7];
    }
}

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

-(void)delayMethod{

    [self.navigationController popViewControllerAnimated:YES];
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
