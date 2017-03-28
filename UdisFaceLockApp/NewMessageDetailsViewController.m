//
//  NewMessageDetailsViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/9/19.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "NewMessageDetailsViewController.h"

@interface NewMessageDetailsViewController ()<UITextViewDelegate>

@end

@implementation NewMessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationItem.title = @"消息内容";
    //标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self creatTextView];

}

-(void)creatTextView{

    UITextView *messageTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 70, self.view.frame.size.width-40, self.view.frame.size.height-70-49)];
    NSString *message = [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
    messageTextView.text = [NSString stringWithFormat:@"%@", message];
    messageTextView.editable = NO; // Not editable
    messageTextView.selectable = NO;// Can not be selected
    messageTextView.textAlignment = NSTextAlignmentJustified; // Justified
    messageTextView.delegate = self;
    
    [self.view addSubview:messageTextView];
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
