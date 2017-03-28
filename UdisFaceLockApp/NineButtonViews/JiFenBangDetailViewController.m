//
//  JiFenBangDetailViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/1/11.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "JiFenBangDetailViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPSessionManager.h"

@interface JiFenBangDetailViewController ()<UIWebViewDelegate>

@end

@implementation JiFenBangDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _c2L=[_c2L stringByReplacingOccurrencesOfString:@"http"withString:@"https"];
    //NSLog(@"replaceStr=%@",string);
    NSLog(@"_c2L is %@",_c2L);
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self loadData];
}

-(void)loadData{
    
    NSString *string = @"php";
    if (![_c2L containsString:string]) {
        [self showAlert:@"没油信息"];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.7];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"application/json", @"text/plain", nil]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:_c2L parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取新闻内容成功");
        
       // NSLog(@"responseObject is %@",responseObject);
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        webView.scalesPageToFit = YES;
        NSStringEncoding enc= CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        NSString *rawString=[[NSString alloc]initWithData:responseObject encoding:enc];
        NSLog(@"result is %@", rawString);
        [webView loadHTMLString:rawString baseURL:nil];
        [self.view addSubview:webView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取新闻内容失败");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"新闻内容 error is%@",error);
        //[self showAlert:@"新闻内容获取失败，请返回重试!"];
    }];
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidStartLoad");
    //[MBProgressHUD showHUDAddedTo:webView animated:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:webView animated:YES];
    NSLog(@"webViewDidFinishLoad");
    
    
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    
    NSLog(@"DidFailLoadWithError");
    [MBProgressHUD hideHUDForView:webView animated:YES];
    
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
