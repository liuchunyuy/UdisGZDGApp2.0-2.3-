

#import "LeftViewController.h"
#import "SubViewController.h"
#import "ServerSettingController.h"
#import "PersonInfoController.h"
#import "NewMessageController.h"


@interface LeftViewController ()
{
    NSArray *_arData;
}

@end

@implementation LeftViewController

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    //_arData = @[@"新闻", @"订阅", @"图片", @"视频", @"跟帖", @"电台"];
   // _arData = @[@"个人中心",@"设置服务器",@"退出系统"];
   // _arData = @[@"个人中心",@"退出系统"];
     _arData = @[@"个人中心",@"最新消息",@"退出系统"];
    //_arData = @[@"设置服务器"];
    
    /*
     UIButton *toNewViewbtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [toNewViewbtn setFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 170, CGRectGetHeight(self.view.frame) - 60, 60, 30)];
     [toNewViewbtn setTitle:@"新页面" forState:UIControlStateNormal];
     [toNewViewbtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
     [toNewViewbtn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
     [toNewViewbtn addTarget:self action:@selector(toNewViewbtn:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:toNewViewbtn];
     */
    
    __block float h = self.view.frame.size.height*0.7/[_arData count];
    __block float y = 0.15*self.view.frame.size.height;
    [_arData enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         UIView *listV = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, h)];
         [listV setBackgroundColor:[UIColor clearColor]];
         
         
         UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, listV.frame.size.width - 60, listV.frame.size.height)];
         [l setFont:[UIFont systemFontOfSize:20]];
         [l setTextColor:[UIColor whiteColor]];
         [l setBackgroundColor:[UIColor clearColor]];
         [l setText:obj];
         //add by Gavin
         //l.userInteractionEnabled=YES;
         //UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingServer:)];
         //[l addGestureRecognizer:labelTapGestureRecognizer];
         
         switch(idx){
             case 0  :
             {
                 l.userInteractionEnabled=YES;
                 UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(persionalCentre:)];
                 [l addGestureRecognizer:labelTapGestureRecognizer];
             }
                 break;
             
//             case 1  :
//             {
//                 l.userInteractionEnabled=YES;
//                 UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingServer:)];
//                 [l addGestureRecognizer:labelTapGestureRecognizer];
//             }
//                 break;
                 
             case 1  :
             {
                 l.userInteractionEnabled=YES;
                 UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newMessage)];
                 [l addGestureRecognizer:labelTapGestureRecognizer];
             }
                 break;
             
             case 2  :
             {
                 l.userInteractionEnabled=YES;
                 UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction:)];
                 [l addGestureRecognizer:labelTapGestureRecognizer];
             }
                 break;
            
                 
             default :
                 break;
         }
         
         [listV addSubview:l];
         [self.view addSubview:listV];
         y += h;
         //Remove by Gavin
         //UITapGestureRecognizer *tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)];
         //[listV addGestureRecognizer:tapGestureRec];
     }];
}

-(void)newMessage{

    NewMessageController *newMessageController = [[NewMessageController alloc]init];
    [self.navigationController pushViewController:newMessageController animated:YES];
    
}

//退出
- (void)backAction:(id)sender
{
    //[[QHSliderViewController sharedSliderController] closeSideBar];∫
    exit(0);
}

//最新消息
- (void)settingServer:(UIButton *)btn
{
    ServerSettingController *serverSettingController = [[ServerSettingController alloc] initWithFrame:[UIScreen mainScreen].bounds andSignal:@"new view"];
    NSLog(@"----------------");
    [[QHSliderViewController sharedSliderController].navigationController pushViewController:serverSettingController animated:YES];
}

//个人中心
- (void)persionalCentre:(UIButton *)btn
{
    PersonInfoController *personInfoController = [[PersonInfoController alloc] initWithFrame:[UIScreen mainScreen].bounds andSignal:@"new view"];
    [[QHSliderViewController sharedSliderController].navigationController pushViewController:personInfoController animated:YES];
}

////设置服务器
//- (void)settingServer:(UIButton *)btn
//{
//    ServerSettingController *serverSettingController = [[ServerSettingController alloc] initWithFrame:[UIScreen mainScreen].bounds andSignal:@"new view"];
//    [[QHSliderViewController sharedSliderController].navigationController pushViewController:serverSettingController animated:YES];
//}

/*
- (void)toNewViewbtn:(UIButton *)btn
{
    //    [[QHSliderViewController sharedSliderController] closeSideBarWithAnimate:YES complete:^(BOOL finished)
    //    {
    //    }];
    SubViewController *subViewController = [[SubViewController alloc] initWithFrame:[UIScreen mainScreen].bounds andSignal:@"new view"];
    [[QHSliderViewController sharedSliderController].navigationController pushViewController:subViewController animated:YES];
}
*/

@end
