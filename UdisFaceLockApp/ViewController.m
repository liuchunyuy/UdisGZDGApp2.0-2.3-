//
//  ViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/4/13.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "ViewController.h"
#import "RegisteredController.h"

#import "UIImageView+WebCache.h"
@interface ViewController ()
{
    NSInteger secondsCountDown;//倒计时总时长
    NSTimer *countDownTimer;
}

@property(strong,nonatomic)UILabel *timeLabel;
@property(nonatomic,copy)NSMutableArray *netImageArr;
@property(nonatomic,strong)UIImageView *imageVc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _netImageArr = [NSMutableArray array];
    
   // [self getImageUrl];   //启动图加载网络图片
    
    UIImage *image = [UIImage imageNamed:@"appWork"];
    _imageVc = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _imageVc.image = image;
    [self.view addSubview:_imageVc];
    
    secondsCountDown = 3;//倒计时秒数
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 countDownAction
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.frame = CGRectMake(self.view.frame.size.width - 100, 30, 50, 20);
    self.timeLabel.textColor = [UIColor redColor];
    [self.timeLabel setFont:[UIFont systemFontOfSize:13]];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.layer.borderColor = [[UIColor grayColor]CGColor];
    self.timeLabel.layer.borderWidth = 0.5f;
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.layer.cornerRadius = 5;
    self.timeLabel.text = [NSString stringWithFormat:@"%ld s",(long)secondsCountDown];
    [_imageVc addSubview:self.timeLabel];
    
}

-(void)getImageUrl{

    NSURL *url1 = [NSURL URLWithString:start_IMAGE_URL];
    NSURLRequest *urlR = [NSURLRequest requestWithURL:url1];
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlR completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *rec = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (rec == nil) {
            return ;
        }
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[rec dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"start image dic is %@",dic);
        for (NSDictionary *dic1 in dic) {
            NSString *imgUrl =  [dic1 objectForKey:@"imgUrl"];
            NSLog(@"start image url is %@",imgUrl);
            [_netImageArr addObject:imgUrl];
            NSLog(@"_netImageArr is %@",_netImageArr);
        }
        [_imageVc sd_setImageWithURL:[NSURL URLWithString:_netImageArr[0]] placeholderImage:[UIImage imageNamed:@"moren1"]];
        
    }];
    [dataTask resume];
}

-(void) countDownAction{
    //倒计时-1
    secondsCountDown--;
    
    //修改倒计时标签现实内容
    self.timeLabel.text=[NSString stringWithFormat:@"%ld s",(long)secondsCountDown];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    RegisteredController *registerVc = [[RegisteredController alloc]init];
    if(secondsCountDown==0){
        [self presentViewController:registerVc animated:YES completion:nil];
    }
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
