//
//  SetViewController.m
//  CloudShop
//
//  Created by meng jianhua on 14-4-3.
//  Copyright (c) 2014年 mengjianhua. All rights reserved.
//

#import "PersonInfoController.h"
#import "MyUtiles.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+HM.h"
#import "ZLAlertView.h"
#import "MBProgressHUD.h"

#import <MessageUI/MessageUI.h>

#define IOS7 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
#define IOS8 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
#define IOS9 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 9.0)


@interface PersonInfoController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UINavigationBarDelegate,MFMailComposeViewControllerDelegate>{

    NSString *_newMesage;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource1;
//@property (nonatomic, strong) NSArray *dataSource2;

@end

@implementation PersonInfoController

- (id)initWithFrame:(CGRect)frame andSignal:(NSString *)szSignal{
    
    self = [super init];
    if (self){
        /*
        self.szSignal = szSignal;
        self.view.frame = frame;
        self.title = szSignal;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.view.layer.borderWidth = 1;
        self.view.layer.borderColor = [UIColor blueColor].CGColor;
         */
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    //self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    //改变导航栏颜色
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    
    
    /* 此方法设置nav透明和隐藏下划线，但是回影响到下一个页面的nav，所以采用nav的代理方法隐藏本页面的nav
    //设置nav透明
    self.navigationController.navigationBar.translucent = YES;
    UIColor *color = [UIColor clearColor];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //去除nav下的黑线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    */
    self.navigationController.delegate = self; //实现nav代理隐藏本页面的nav
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.dataSource1 = [NSArray arrayWithObjects:@"手机号码",@"姓名",@"修改密码",nil];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 240) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    //[self.view addSubview:self.tableView];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.layer.cornerRadius = 5;
    exitBtn.backgroundColor = [UIColor redColor];
    [exitBtn setFrame:CGRectMake((self.view.frame.size.width-220)/2, 380,220, 30)];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [exitBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:exitBtn];
    
    [self creatView];
    [self creatHeadImg];

}

-(void)creatHeadImg{

    UIImage *image = [UIImage imageNamed:@"head"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    UIImage *image1 = [UIImage imageNamed:@"header1"];
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-50)/2, 70, 50, 50)];
    imageView1.image = image1;
    [imageView addSubview:imageView1];
}

-(void)creatView{
    
    UILabel *numLabel = [MyUtiles createLabelWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 200, 100, 30) font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft color:[UIColor blackColor] text:@"手机号码:"] ;
    [self.view addSubview:numLabel];
    
    NSString *user=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    UILabel *numLabel1 = [MyUtiles createLabelWithFrame:CGRectMake((self.view.frame.size.width-220)/2+100, 200, 120, 30) font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentRight color:[UIColor blackColor] text:user];
    //numLabel1.text = [NSString stringWithFormat:@"%@",user];
    [self.view addSubview:numLabel1];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 230, 220, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
        
    UILabel *userNameLabel = [MyUtiles createLabelWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 240, 100, 30) font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft color:[UIColor blackColor] text:@"用户姓名:"];
    [self.view addSubview:userNameLabel];
    
    NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    UILabel *userNameLabel1 = [MyUtiles createLabelWithFrame:CGRectMake((self.view.frame.size.width-220)/2+100, 240, 120, 30) font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentRight color:[UIColor blackColor] text:username];
   // userNameLabel1.text = [NSString stringWithFormat:@"%@",username];
    [self.view addSubview:userNameLabel1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 270, 220, 1)];
    lineView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView2];
    
    UIButton *modiBtn = [MyUtiles createBtnWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 280, 220, 30) title:@"修改密码" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(modiPassword)];
    [modiBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [modiBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    modiBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    modiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;  //按钮文子居左
    modiBtn.backgroundColor = [UIColor clearColor];
    UIImage *image = [UIImage imageNamed:@"arrow_right2@2x"];
    [modiBtn setImage:image forState:UIControlStateNormal];
    /*
     setTitleEdgeInsets 设置button上文字位置（距上，左，下，右）
     setImageEdgeInsets 设置button上图片位置（距上，左，下，右）
     */
    [modiBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [modiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, modiBtn.bounds.size.width-image.size.width, 0, -modiBtn.bounds.size.width)];
    [self.view addSubview:modiBtn];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 310, 220, 1)];
    lineView3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView3];
    
    UIButton *clearBtn = [MyUtiles createBtnWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 320, 220, 30) title:@"清除缓存" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(clearTmpPics)];
    [clearBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;  //按钮文子居左
    clearBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:clearBtn];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 350, 220, 1)];
    lineView4.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView4];
    
    UIButton *ideaBtn = [MyUtiles createBtnWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 360, 220, 30) title:@"意见反馈" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(idea)];
    [ideaBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [ideaBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    ideaBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    ideaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;  //按钮文子居左
    ideaBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:ideaBtn];
    
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 390, 220, 1)];
    lineView5.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView5];

}

-(void)idea{
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController.navigationBar setTintColor:[UIColor whiteColor]];
        [mailController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [mailController setSubject:@"标题"];
        [mailController setMessageBody:@"邮件内容" isHTML:NO];
        [mailController setToRecipients:@[@"liuchunyuy@163.com"]];
       // [mailController setCcRecipients:@[@"抄送人1", @"抄送人2",]];
       // [mailController setBccRecipients:@[@"密送人1", @"密送人2",]];
        //if (mailController)
            [self presentViewController:mailController animated:YES completion:nil];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"不能发送邮件" message:@"请检查设置-邮件-帐户是否添加了帐户及邮件是否为打开状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // 关闭邮件界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if(result == MFMailComposeResultCancelled) {
        NSLog(@"取消发送");
    } else if(result == MFMailComposeResultSent) {
        NSLog(@"已经发出");
        [self showAlert:@"已发送"];
    } else {
        NSLog(@"发送失败");
        [self showAlert:@"发送失败，稍后再试"];
    }
}

-(void)clearTmpPics{
    
    if (IOS8) {
        
        NSLog(@"systemVersion >= 8");
        float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
        NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
        NSString *message = [NSString stringWithFormat:@"%@ ?", clearCacheName];
        NSLog(@"clearCacheName is %@", clearCacheName);
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"clear disk");
            [self showHUD];
            [[SDImageCache sharedImageCache] clearDisk];
            //[[SDImageCache sharedImageCache] clearMemory];
            [self hideHUD];
        }];
        [alertC addAction:cancelAction];
        [alertC addAction:defaultAction];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }else {
        
        NSLog(@"systemVersion < 8");
        float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
        NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
        NSString *message = [NSString stringWithFormat:@"%@ ?", clearCacheName];
        NSLog(@"clearCacheName is %@", clearCacheName);

        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertV show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        NSLog(@"clear disk");
        [self showHUD];
        [[SDImageCache sharedImageCache] clearDisk];
        //[[SDImageCache sharedImageCache] clearMemory];
        [self hideHUD];
    }
}

-(void)exit{

    //exit(0);
    ZLAlertView *alert = [[ZLAlertView alloc]initWithTitle:@"退出登录?" message:@"退出后,您需重新登录才能操控设备."];
    [alert addBtnTitle:@"取消" action:^{
        return ;
    }];
    [alert addBtnTitle:@"确定" action:^{
        exit(0);
    }];
    [alert showAlertWithSender:self];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableViewDelegate method -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1; // [dataSourse count]分组   1非分组
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = @"cell";
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    
    //cell右边的显示方式
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    //第一个section
    if (indexPath.section == 0 ) {
        cell.textLabel.text = self.dataSource1[row];
        if (indexPath.row == 0) {
            NSString *user=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
            NSLog(@"user is %@",user);
            cell.detailTextLabel.text = user;
        }
        if (indexPath.row == 1) {
            NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
            NSLog(@"user is %@",username);
            cell.detailTextLabel.text = username;
        }
        if (indexPath.row == 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    //第一个section
    if (indexPath.section == 0) {
        switch (row) {
            /*
            case 0:
                [self LocationPath:0];
                break;
            case 1:
                [self VideoScan:0];
                break;
             */
            case 2:
                [self modiPassword];
                break;
            
            case 3:
                exit(0);
                break;
             
            default:
                break;
        }
    }
}


-(void)modiPassword{

    self.hidesBottomBarWhenPushed = YES;
    ModiPasswordController *modiPassWordVc = [[ModiPasswordController alloc]init];
    [self.navigationController pushViewController:modiPassWordVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

//隐藏本页面的nav

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

-(void)superBackButtonTouchEvent:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)pushVC:(UIViewController *)ViewVC{
    
    [self.navigationController pushViewController:ViewVC animated:YES];
}

-(void)AlertLogMsg:(NSString *)logMsg{
    NSLog(@"您选择了%@",logMsg);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:logMsg message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

// Pop-up box
- (void)timerFireMethod:(NSTimer*)theTimer{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{// time
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

@end
