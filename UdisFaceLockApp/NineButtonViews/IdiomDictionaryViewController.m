//
//  IdiomDictionaryViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/23.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "IdiomDictionaryViewController.h"
#import "MyUtiles.h"
#import "MBProgressHUD.h"
#import "AFHTTPSessionManager.h"

#define kIdiomDictionary @"http://v.juhe.cn/chengyu/query?key=4e0558af0c5277e9ce5cdbfe5abc417b&word=%@"
#define VIEW_HEIGTH self.view.frame.size.height
#define VIEW_WEIGHT self.view.frame.size.width
@interface IdiomDictionaryViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@end

@implementation IdiomDictionaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"成语字典";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.extendedLayoutIncludesOpaqueBars = YES;// 延伸导航栏至（0.0)
    
    //添加self.view的点击事件（点击屏幕空白取消键盘）
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    [self creatView];
}

-(void)creatView{
    
    _idiomTextField = [MyUtiles createTextField:CGRectMake((VIEW_WEIGHT-200)/2, 65, 200, 40) placeholder:@"此处输入成语" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor whiteColor] keyboardType:UIKeyboardTypeDefault viewMode:UITextFieldViewModeAlways secureTextEntry:NO];
    _idiomTextField.textAlignment = NSTextAlignmentLeft;
    [_idiomTextField endEditing:YES];
    _idiomTextField.layer.masksToBounds = YES;
    _idiomTextField.layer.cornerRadius = 5;
    _idiomTextField.returnKeyType = UIReturnKeySearch;
    _idiomTextField.delegate = self;
    [self.view addSubview:_idiomTextField];
    
    UIButton *searchBtn = [MyUtiles createBtnWithFrame:CGRectMake((VIEW_WEIGHT-60)/2, 105, 60, 30) title:@"搜索" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(loadData)];
    searchBtn.backgroundColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 5;
    [searchBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [searchBtn.layer setBorderWidth:1];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_idiomTextField resignFirstResponder];
    [self loadData];
    return YES;
}

-(void)loadData{
    
    [_idiomTextField endEditing:YES];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([_idiomTextField.text isEqualToString:@""]) {
        [self showAlert:@"您还没有输入要查询的成语"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *url = [NSString stringWithFormat:kIdiomDictionary,_idiomTextField.text];
        NSString *str = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"成语查询成功");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"成语查询 responseObject is %@",responseObject);
            NSString *codeNum = [[responseObject objectForKey:@"error_code"] stringValue];
            NSString *reason = [responseObject objectForKey:@"reason"];
            NSLog(@"code is %@", codeNum);
            if ([codeNum isEqualToString:@"215702"] ) {
                [self showAlert:reason];
                return ;
            }else{
                NSDictionary *newsDic = [responseObject objectForKey:@"result"];
                
                NSString *chengyujs =[NSString stringWithFormat:@"%@",[newsDic objectForKey:@"chengyujs"]];
                NSString *ciyujs =[NSString stringWithFormat:@"%@",[newsDic objectForKey:@"ciyujs"]];
                NSString *example =[NSString stringWithFormat:@"%@",[newsDic objectForKey:@"example"]];
                NSString *from_ =[NSString stringWithFormat:@"%@",[newsDic objectForKey:@"from_"]];
                NSString *fanyi =[NSString stringWithFormat:@"%@",[newsDic objectForKey:@"fanyi"][0]];
                NSString *tongyi =[NSString stringWithFormat:@"%@",[newsDic objectForKey:@"tongyi"][0]];
                //NSString *yinzhengjs =[NSString stringWithFormat:@"%@",[newsDic objectForKey:@"yinzhengjs"]];
                
                NSArray *arr = @[chengyujs,ciyujs,example,from_,fanyi,tongyi];
                for (int i = 0; i < 6; i++) {
                    
                    UILabel *label = [[UILabel alloc]init];
                    label.font = [UIFont systemFontOfSize:13];
                    label.text = arr[i];
                    label.textAlignment = NSTextAlignmentLeft;
                    label.backgroundColor = [UIColor orangeColor];
                    label.numberOfLines = 0;//根据最大行数需求来设置
                    //初始化段落，设置段落风格
                    NSMutableParagraphStyle *paragraphstyle=[[NSMutableParagraphStyle alloc]init];
                    paragraphstyle.lineBreakMode=NSLineBreakByCharWrapping;
                    paragraphstyle.headIndent = 20; //首行缩进
                    paragraphstyle.lineSpacing=10; //行距
                    //设置label的字体和段落风格
                    NSDictionary *dic=@{NSFontAttributeName:label.font,NSParagraphStyleAttributeName:paragraphstyle.copy};
                    //NSDictionary *dic=@{NSFontAttributeName:self.label.font};
                    //计算label的真正大小,其中宽度和高度是由段落字数的多少来确定的，返回实际label的大小
                    CGRect rect=[label.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
                    //设置到屏幕顶部的距离，如果不设置就x,y都为0
                    
                    label.frame=CGRectMake(10, 140+70*i, rect.size.width,rect.size.height);
                    //label.frame = CGRectMake(10, 140+40*i, expectSize.width, expectSize.height);
                    [self.view addSubview:label];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"成语查询失败");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"成语查询 error is%@",error);
            [self showAlert:@"成语查询失败，请重试!"];
        }];

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

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.nameTextField resignFirstResponder];
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
