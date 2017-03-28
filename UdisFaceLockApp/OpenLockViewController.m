//
//  OpenLockViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/9/7.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "OpenLockViewController.h"
#import "MyUtiles.h"
#import "SubViewController.h"
#import "TouchPropagatedScrollView.h"
#import "Config.h"
#import "MBProgressHUD.h"
#import "SZKRoundScrollView.h"
#import "SingletonSocket.h"
@interface OpenLockViewController ()<UIScrollViewDelegate>{
    
    //Device *currentDevice;//当前选择的锁
    NSDictionary *currentDevice;
    
    //定义弹出窗口
    CNPPopupController *popupController;

}

@property(nonatomic)BOOL isLogined;

@end

@implementation OpenLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"开门";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.extendedLayoutIncludesOpaqueBars = YES;// 延伸导航栏至（0.0
    
    [self createAnim];
    [self creatOpenBtn];
    [self creatLabel];
    
}

-(void)creatOpenBtn{

    UIButton *btn = [MyUtiles createBtnWithFrame:CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height/2-40, 80, 80) title:@"开门" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(openLock)];
    //btn.backgroundColor = [UIColor colorWithRed:127/255.f green:255/255.f blue:212/255.f alpha:1.0];
    //btn.layer.cornerRadius = 40;
    //btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //btn.layer.borderWidth = 0.5f;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    btn.titleLabel.font = [UIFont fontWithName:@"Zapfino" size:16];
    [self.view addSubview:btn];

}

-(void)openLock{

    NSArray *devices = [[NSUserDefaults standardUserDefaults] arrayForKey:@"devices"];
    NSMutableArray *deviceDataArray = [devices mutableCopy];
    if (((unsigned long)deviceDataArray.count)>0) {
        if (((unsigned long)deviceDataArray.count)==1) {//只有一台设备，不弹出窗口
            currentDevice=[[NSDictionary alloc]init];
            currentDevice = [deviceDataArray objectAtIndex:0];
            //当前锁信息
            NSLog(@"current deviceitem name is %@",[currentDevice objectForKey:@"devicename"]);
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            if(clientSocket==nil){
                
                [self ConnectToSever];//连接服务器
                [self sendOpenLockData:currentDevice];
                
            }else{
                
                [self sendOpenLockData:currentDevice];
            }
            
        }else{
            //生成锁名称列表
            NSMutableArray *deviceLockNumberArray= [self getDeviceName:deviceDataArray];
            NSArray *titles = [deviceLockNumberArray copy];//锁名称列表
            //NSArray *titles = @[@"item1", @"选项2", @"选项3"];
            CGPoint point = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
            PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
            pop.selectRowAtIndex = ^(NSInteger index){
                NSLog(@"select index:%ld", (long)index);
                NSLog(@"Index :%@", [titles objectAtIndex:index]);
                if (deviceDataArray) {
                    currentDevice=[[NSDictionary alloc]init];
                    for (currentDevice in deviceDataArray) {
                        //NSLog(@"deviceitem pid is %d",currentDevice.pid);
                        if ([[titles objectAtIndex:index] isEqualToString:[currentDevice objectForKey:@"devicename"]]) {
                            break;
                        }
                    }
                    //当前锁信息
                    NSLog(@"current deviceitem name is %@",[currentDevice objectForKey:@"devicename"]);
                    
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    if(clientSocket==nil)
                    {
                        [self ConnectToSever];//连接服务器
                        [self sendOpenLockData:currentDevice];
                        //NSLog(@"sock is null !");
                        //[self showAlert:@"连接服务器失败，请检查设置!!"];
                    }else{
                        [self sendOpenLockData:currentDevice];
                    }
                }
            };
            [pop show];
        }
    }else{
        [Utils showAlert:@"亲，没有锁，请联系管理员"];
    }
}

//生成设备序号列表
- (NSMutableArray*) getDeviceName:(NSMutableArray*) devices{
    if (((unsigned long)devices.count)>0) {
        NSMutableArray *deviceLockNumberArray= [NSMutableArray new];
        //生成锁号列表
        for (NSDictionary *device in devices) {
            //NSString *deviceid = [device objectForKey:@"deviceid"];
            NSString *devicename  = [device objectForKey:@"devicename"];
            //NSLog(@"deviceid=%@, devicename=%@", deviceid, devicename);
            [deviceLockNumberArray addObject:devicename];
        }
        return deviceLockNumberArray;
    }
    return NULL;
}

- (void)sendOpenLockData:(NSDictionary *)device{
    //- (void)sendOpenLockData{
    NSLog(@"sendOpenLockData!");
    NSString *user=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSLog(@"user is %@",user);
    
    //开始拼接Json字符串
    NSDictionary *parmDictionary= [NSDictionary dictionaryWithObjectsAndKeys:user,@"user",
                                   @"",@"password",
                                   @"",@"cardnumber",
                                   @"",@"visitmobil",
                                   @"",@"visitname",
                                   [device objectForKey:@"deviceid"],@"deviceid",
                                   @"",@"newpassword",
                                   @"",@"messageID",nil];
    NSDictionary *jsonDictionary=[NSDictionary dictionaryWithObjectsAndKeys:@"Remote",@"command",
                                  parmDictionary,@"parameter",nil];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    NSString * inputMsgStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * content = [[_MESSAGE_START stringByAppendingString:inputMsgStr] stringByAppendingString:_MESSAGE_END];
    NSLog(@"send action is: %@",content);
    NSData *sendata = [content dataUsingEncoding:NSISOLatin1StringEncoding];
    [clientSocket writeData:sendata withTimeout:20 tag:100];
    self.isLogined = NO;
    [self performSelector:@selector(checkIsLogined) withObject:nil afterDelay:20];
    
}

-(void)checkIsLogined{
    if (self.isLogined) {
        //已经登录
    }else{
        //未登录
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showAlert:@"系统忙，稍候再试 "];
        clientSocket = nil;
    }
}

//接收数据
-(void)receiveData :(NSData *)data{
    
    NSString *totalmessage=@"";
    if (data) {
        NSString *recvMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"recvMessage is: %@",recvMessage);
        if(recvMessage){
            totalmessage=[totalmessage stringByAppendingString:recvMessage];
            NSLog(@"totalmessage is: %@",totalmessage);
            NSRange rangeStart = [totalmessage rangeOfString:_MESSAGE_START];
            int locationStrat = rangeStart.location;
            int leightStart = rangeStart.length;
            NSLog(@"start is %d,%d",locationStrat,leightStart);
            NSRange rangeEnd = [totalmessage rangeOfString:_MESSAGE_END];
            int locationEnd = rangeEnd.location;
            int leightEnd = rangeEnd.length;
            NSLog(@"end is %d,%d",locationEnd,leightEnd);
            if (leightStart>0 && leightEnd>0 ) {//接收到完整的数据
                //取消登陆等待框
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                //截取掉前后 udis 标志
                NSString *needmessage=[[totalmessage substringToIndex:locationEnd] substringFromIndex:leightStart];
                NSLog(@"needmessage is: %@",needmessage);
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[needmessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                //totalmessage=@"";
                NSLog(@"dic=%@",dic);
                if([dic objectForKey:@"command"]){//含有command 节点
                    NSString *command=[dic objectForKey:@"command"];
                    NSLog(@"command is: %@",command);
                    //远程开门
                    if ([command isEqual:@"Remote"]) {
                        NSLog(@"Remote!!!!");
                        if([dic objectForKey:@"code"]){
                            NSString *code=[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
                            NSLog(@"code is: %@",code);
                            
                            if ([code isEqual:@"1"]) {
                                [Utils showAlert:@"设备有问题，开门失败，请联系管理员!"];
                            }
                            if ([code isEqual:@"2"]) {
                                [Utils showAlert:@"数据有问题，开门失败，请联系管理员!"];
                            }
                            if ([code isEqual:@"3"]) {
                                [Utils showAlert:@"系统异常，开门失败，请联系管理员!"];
                            }
                            if ([code isEqual:@"0"]) {
                                [Utils showAlert:@"开门成功！"];
                            }
                        }
                    }
                }
            }
        }
    }
}

- (void) ConnectToSever{
    
    if(clientSocket==nil){
        clientSocket=[[AsyncSocket alloc] initWithDelegate:self];
        NSError *error=nil;
        NSString *address = [clientSocket getProperIPWithAddress:_SERVER_ADDRESS port:_SERVER_PORT];
        if(![clientSocket connectToHost:address onPort:_SERVER_PORT withTimeout:5 error:&error]){
            clientSocket = nil;
            NSLog(@"Connect fail!");
        }else{
            NSLog(@"Connect sucess!");
        }
    }else{
        NSLog(@"Connected!");
    }
}

#pragma AsyncScoket Delagate
/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    
    NSLog(@"didConnectToHost:onSocket:%p didConnectToHost:%@ port:%hu",sock,host,port);
    /* readDataWithTimeout:-1 否则就自动断开连接 */
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
    //[sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];  // 这句话仅仅接收\r\n的数据
    NSLog(@"didWriteDataWithTag");
    [sock readDataWithTimeout: -1 tag: 0];
    //[sock readDataWithTimeout:-1 buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    self.isLogined = YES;
    NSLog(@"didReadData");
    NSLog(@"data is: %@",data);
    [self receiveData:data];
    [sock readDataWithTimeout:-1 tag:0];
    
}

- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag{
    
    NSLog(@"onSocket:%p didSecure:YES", sock);
    
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    
    NSLog(@"willDisconnectWithError: onSocket:%p willDisconnectWithError:%@", sock, err);
    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    
    if (!self.isLogined) {
        return;
    }
    //断开连接了
    NSLog(@"onSocketDidDisconnect:%p", sock);
    NSString *msg = @"Sorry this connect is failure";
    NSLog(@"%@", msg);
    clientSocket = nil;
    //[self showAlert:@"连接服务器失败，请检查设置!!"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils showAlert:_SOCKET_CONNECT_FAIL];
}

#pragma end Delegate

- (void)timerFireMethod:(NSTimer*)theTimer{  //弹出框

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

//添加波纹动画
-(void)createAnim{
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2) radius:10 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2) radius:120 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = startPath.CGPath;
    //线宽
    layer.lineWidth = 1.0;
    //填充色
    layer.fillColor = [UIColor clearColor].CGColor;
    //线条色
    //layer.strokeColor = [UIColor orangeColor].CGColor;
    layer.strokeColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0].CGColor;
    [self.view.layer addSublayer:layer];
    //添加动画
    CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnim.fromValue = (__bridge id _Nullable)(startPath.CGPath);
    pathAnim.toValue = (__bridge id _Nullable)(endPath.CGPath);
    pathAnim.duration = 2.0;
    pathAnim.removedOnCompletion = YES;
    pathAnim.fillMode = kCAFillModeForwards;
    pathAnim.repeatCount = MAXFLOAT;
    [layer addAnimation:pathAnim forKey:@"path"];
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(1);
    opacityAnim.toValue = @(0);
    opacityAnim.duration = 2.0;
    opacityAnim.repeatCount = MAXFLOAT;
    opacityAnim.fillMode = kCAFillModeForwards;
    opacityAnim.removedOnCompletion = YES;
    [layer addAnimation:opacityAnim forKey:@"opacity"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = startPath.CGPath;
        //线宽
        layer.lineWidth = 1.0;
        //填充色+9
        layer.fillColor = [UIColor clearColor].CGColor;
        //线条色
        layer.strokeColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0].CGColor;
        [self.view.layer addSublayer:layer];
        [layer addAnimation:pathAnim forKey:@"path"];
        [layer addAnimation:opacityAnim forKey:@"opacity"];
        
    });
}

-(void)creatLabel{
 
    UILabel *label = [MyUtiles createLabelWithFrame:CGRectMake((self.view.frame.size.width-150)/2, self.view.frame.size.height-120, 60, 30) font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter color:[UIColor lightGrayColor] text:@"智慧生活"];
    [self.view addSubview:label];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-150)/2+75, self.view.frame.size.height-112.5, 1, 15)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    UILabel *label1 = [MyUtiles createLabelWithFrame:CGRectMake((self.view.frame.size.width-150)/2+90, self.view.frame.size.height-120, 60, 30) font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter color:[UIColor lightGrayColor] text:@"你我共享"];
    [self.view addSubview:label1];

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
