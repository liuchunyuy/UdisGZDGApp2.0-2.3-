//
//  QRCodeViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/9/7.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "QRCodeViewController.h"
#import "SubViewController.h"
#import "TouchPropagatedScrollView.h"
#import "Config.h"
#import "MBProgressHUD.h"
#import "SZKRoundScrollView.h"
#import "MyUtiles.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#define VIEW_HEIGTH self.view.frame.size.height
#define VIEW_WEIGHT self.view.frame.size.width

@interface QRCodeViewController ()<CNPPopupControllerDelegate,UIGestureRecognizerDelegate>
{

    //Device *currentDevice;//当前选择的锁
    NSDictionary *currentDevice;
    
    //访客
    UITextField *visitnameTextField;
    UITextField *visitmobilTextField;
    UIButton  *qrcodeConfirm;
    NSString *cardNumber;
    //定义弹出窗口
    CNPPopupController *popupController;

}
@property(nonatomic)BOOL isLogined;
@property(nonatomic,strong)NSString *totalmessage;
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"二维码";
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    
    //关闭软键盘使用
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;

    //nav背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    //nav字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    _totalmessage = @"";
    
    self.extendedLayoutIncludesOpaqueBars = YES;// 延伸导航栏至（0.0
    [self initPageViewQRcodes];
    [self creatLabel1];
    [self createAdvertisement];
}

//二维码界面
- (void)initPageViewQRcodes
{
    NSLog(@"进入二维码界面");
        
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 130, 220, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    
    visitnameTextField = [MyUtiles createTextField:CGRectMake((self.view.frame.size.width-220)/2,100, 220, 30) placeholder:@"请输入访客姓名" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor clearColor] keyboardType:UIKeyboardTypeNumbersAndPunctuation viewMode:UITextFieldViewModeAlways secureTextEntry:NO];
    [visitnameTextField endEditing:YES];
    [self.view addSubview:visitnameTextField];
    
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2,180, 220, 1)];
    lineView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView1];
    
    visitmobilTextField = [MyUtiles createTextField:CGRectMake((self.view.frame.size.width-220)/2, 150, 220, 30) placeholder:@"请输入访客手机号" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor clearColor] keyboardType:UIKeyboardTypeNumbersAndPunctuation viewMode:UITextFieldViewModeAlways secureTextEntry:NO];
    [visitmobilTextField endEditing:YES];
    [self.view addSubview:visitmobilTextField];
    
    //生成二维码按钮
    qrcodeConfirm= [UIButton buttonWithType:UIButtonTypeCustom];
    [qrcodeConfirm setFrame:CGRectMake((self.view.frame.size.width-220)/2,220, 220, 30)];
    [qrcodeConfirm setTitle:@"生成二维码" forState:UIControlStateNormal];
    qrcodeConfirm.backgroundColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [qrcodeConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qrcodeConfirm setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    qrcodeConfirm.layer.cornerRadius = 5;
    qrcodeConfirm.titleLabel.font = [UIFont systemFontOfSize:15];
    [qrcodeConfirm addTarget:self action:@selector(QrCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qrcodeConfirm];

}

- (void) ConnectToSever{
    if(clientSocket==nil)
    {
        clientSocket=[[AsyncSocket alloc] initWithDelegate:self];
        
        NSError *error=nil;
        NSString *address = [clientSocket getProperIPWithAddress:_SERVER_ADDRESS port:_SERVER_PORT];
        if(![clientSocket connectToHost:address onPort:_SERVER_PORT withTimeout:5 error:&error]){
            clientSocket = nil;
            NSLog(@"Connect fail!");
        }
        else{
            NSLog(@"Connect sucess!");
        }
    }else{
        NSLog(@"Connected!");
    }
}

//获取当前时间秒
-(NSInteger)calculateCurentSecongOfTime{
    NSDate *date = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:unit fromDate:date];
    return components.second;
}

//生成二维码
-(void)QrCode{
   
    [visitmobilTextField endEditing: YES];
    [visitnameTextField endEditing:YES];
    //获取设备信息
    NSArray *devices = [[NSUserDefaults standardUserDefaults] arrayForKey:@"devices"];
    NSMutableArray *deviceDataArray = [devices mutableCopy];
    if (((unsigned long)deviceDataArray.count)>0) {
        if (((unsigned long)deviceDataArray.count)==1) {//只有一台设备，不弹出窗口
            currentDevice=[[NSDictionary alloc]init];
            currentDevice = [deviceDataArray objectAtIndex:0];
            //当前锁信息
            NSLog(@"current deviceitem name is %@",[currentDevice objectForKey:@"devicename"]);
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if(clientSocket==nil)
            {
                [self ConnectToSever];//连接服务器
                
                [self sendQrCodeData:currentDevice];
            }else{
                [self sendQrCodeData:currentDevice];
            }
        }
        else{
            //生成锁名称列表
            NSMutableArray *deviceLockNumberArray= [self getDeviceName:deviceDataArray];
            NSArray *titles = [deviceLockNumberArray copy];//锁名称列表
            CGPoint point = CGPointMake(qrcodeConfirm.frame.origin.x + qrcodeConfirm.frame.size.width/2, qrcodeConfirm.frame.origin.y + qrcodeConfirm.frame.size.height);
            PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
            pop.selectRowAtIndex = ^(NSInteger index){
                NSLog(@"select index:%ld", (long)index);
                NSLog(@"Index :%@", [titles objectAtIndex:index]);
                if (deviceDataArray) {
                    currentDevice=[[NSDictionary alloc]init];
                    for (currentDevice in deviceDataArray){
                        if ([[titles objectAtIndex:index] isEqualToString:[currentDevice objectForKey:@"devicename"]]) {
                            break;
                        }
                    }
                    //当前锁信息
                    NSLog(@"current deviceitem name is %@",[currentDevice objectForKey:@"devicename"]);
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    if(clientSocket==nil){
                        
                        [self ConnectToSever];//连接服务器
                        [self sendQrCodeData:currentDevice];
                    }else{
                        
                        [self sendQrCodeData:currentDevice];
                    }
                }
            };
            [pop show];            
        }
    }else{
        [Utils showAlert:@"亲，没有锁，请联系管理员"];
    }
}

- (void)sendQrCodeData:(NSDictionary *)device{
    
    [visitmobilTextField endEditing:YES];
    [visitnameTextField endEditing:YES]; // 生成二维码同时关闭键盘
    NSLog(@"sendQrCodeData!");
    NSString *backNumber = [[NSString alloc]init];
    NSString *user=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSLog(@"user is %@",user);
    NSString *qrCode = [NSString stringWithFormat:@"%d",[Utils getRandomNumber:100000 to:1000000]];
    NSLog(@"qrCode is %@", qrCode);
    
    if (visitmobilTextField.text.length > 0) {
        backNumber = visitmobilTextField.text;
    }else{
        backNumber = qrCode;
    }
    //开始拼接Json字符串
    NSDictionary *parmDictionary= [NSDictionary dictionaryWithObjectsAndKeys:user,@"user",
                                   @"",@"password",
                                   qrCode,@"cardnumber",
                                   backNumber,@"visitmobil",
                                   visitnameTextField.text,@"visitname",
                                   //encodeNameStr,@"visitname",
                                   [device objectForKey:@"deviceid"],@"deviceid",
                                   @"",@"newpassword",
                                   @"",@"messageID",nil];
    NSDictionary *jsonDictionary=[NSDictionary dictionaryWithObjectsAndKeys:@"CardNumber",@"command",
                                  parmDictionary,@"parameter",nil];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    NSString * inputMsgStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * content = [[_MESSAGE_START stringByAppendingString:inputMsgStr] stringByAppendingString:_MESSAGE_END];
    NSLog(@"send action is: %@",content);
    NSData *sendata = [content dataUsingEncoding:NSUTF8StringEncoding];
    [clientSocket writeData:sendata withTimeout:-1 tag:0];
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
    
   // NSString *totalmessage=@"";
    if (data) {
        NSString *recvMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"recvMessage is: %@",recvMessage);
        if(recvMessage){
            _totalmessage=[_totalmessage stringByAppendingString:recvMessage];
            NSLog(@"totalmessage is: %@",_totalmessage);
            NSRange rangeStart = [_totalmessage rangeOfString:_MESSAGE_START];
            int locationStrat = rangeStart.location;
            int leightStart = rangeStart.length;
            NSLog(@"start is %d,%d",locationStrat,leightStart);
            NSRange rangeEnd = [_totalmessage rangeOfString:_MESSAGE_END];
            int locationEnd = rangeEnd.location;
            int leightEnd = rangeEnd.length;
            NSLog(@"end is %d,%d",locationEnd,leightEnd);
            if (leightStart>0 && leightEnd>0 ) {//接收到完整的数据
                //取消登陆等待框
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                //截取掉前后 udis 标志
                NSString *needmessage=[[_totalmessage substringToIndex:locationEnd] substringFromIndex:leightStart];
                NSLog(@"needmessage is: %@",needmessage);
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[needmessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                _totalmessage=@"";
                NSLog(@"dic=%@",dic);
                if([dic objectForKey:@"command"]){//含有command 节点
                    NSString *command=[dic objectForKey:@"command"];
                    NSLog(@"command is: %@",command);
                    if ([command isEqual:@"CardNumber"]) {
                        NSLog(@"CardNumber!!!!");
                        if([dic objectForKey:@"code"]){
                            NSString *code=[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
                            NSLog(@"code is: %@",code);

                            if ([code isEqual:@"1"]) {
                                [Utils showAlert:@"卡号下发失败，请重试!"];
                                [self disconnect:clientSocket];
                                clientSocket = nil;
                            }
                            if ([code isEqual:@"2"]) {
                                [Utils showAlert:@"用户或设备不存在，请重试!"];
                                [self disconnect:clientSocket];
                                clientSocket = nil;
                            }
                            if ([code isEqual:@"3"]) {
                                [Utils showAlert:@"系统异常，请重试!"];
                                [self disconnect:clientSocket];
                                clientSocket = nil;
                            }
                            if ([code isEqual:@"0"]) {
                                //[Utils showAlert:@"卡号生成成功!!!"];
                                cardNumber=[NSString stringWithFormat:@"%@",[dic objectForKey:@"desc"]];
                                NSLog(@"cardNumber is: %@",cardNumber);
                                [self showPopupWithStyle:CNPPopupStyleCentered];
                                
                                [self disconnect:clientSocket];
                                clientSocket = nil;
                            }
                        }
                    }
                }
            }
        }
    }
}

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {

    //二维码滤
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜的默认属性
    [filter setDefaults];
    
    //字符串转换为data  输入cardNumber
    NSData *data = [cardNumber dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    //获得滤镜输出的图像
    CIImage *outPutImage = [filter outputImage];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 150, 150);
    imageView.image = [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:150.0];
    
    //弹出图片
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"二维码" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    //二维码图片上访客名字
    NSString * visitName = [@"访客：" stringByAppendingString:visitnameTextField.text] ;
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:visitName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSParagraphStyleAttributeName : paragraphStyle}];
    //二维码有效期说明
    NSAttributedString *lineTwo = [[NSAttributedString alloc] initWithString:@"注意：二维码当天生成,当天有效" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0], NSParagraphStyleAttributeName : paragraphStyle}];
    //二维码图片上门锁名字
    NSAttributedString *lineThree = [[NSAttributedString alloc] initWithString:[currentDevice objectForKey:@"devicename"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13],NSForegroundColorAttributeName : [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0], NSParagraphStyleAttributeName : paragraphStyle}];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UILabel *lineOneLabel = [[UILabel alloc] init];
    lineOneLabel.numberOfLines = 0;
    lineOneLabel.attributedText = lineOne;
    
    UILabel *lineTwoLabel = [[UILabel alloc] init];
    lineTwoLabel.numberOfLines = 0;
    lineTwoLabel.attributedText = lineTwo;
    
    UILabel *lineThreeLabel = [[UILabel alloc] init];
    lineThreeLabel.numberOfLines = 0;
    lineThreeLabel.attributedText = lineThree;
    
    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [button setTitle:@"存盘" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    button.layer.cornerRadius = 4;
    button.selectionHandler = ^(CNPPopupButton *button){
        
        //界面元素保存成图片
        // UIGraphicsBeginImageContext(popupController.outView.bounds.size);
        UIGraphicsBeginImageContext(CGSizeMake(popupController.outView.bounds.size.width, popupController.outView.bounds.size.height-60-40));
        [popupController.outView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //保存二维码图片到相册
        UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
        [popupController dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
        
    };
    CNPPopupButton *button1 = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [button1 setTitle:@"分享" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    button1.layer.cornerRadius = 4;
    button1.selectionHandler = ^(CNPPopupButton *button){
        NSLog(@"点击分享");
        //界面元素保存成图片
        // UIGraphicsBeginImageContext(popupController.outView.bounds.size);
        UIGraphicsBeginImageContext(CGSizeMake(popupController.outView.bounds.size.width, popupController.outView.bounds.size.height-60-40));
        [popupController.outView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        //1、创建分享参数
        NSArray* imageArray = @[viewImage];
        //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        if (imageArray) {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            //[NSURL URLWithString:@"http://mob.com"]
            [shareParams SSDKSetupShareParamsByText:[currentDevice objectForKey:@"devicename"] images:imageArray url:nil title:@"二维码"type:SSDKContentTypeAuto];
            //有的平台要客户端分享需要加此方法，例如微博
            [shareParams SSDKEnableUseClientShare];
            
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                
                NSLog(@"state is %lu",(unsigned long)state);
                NSLog(@"error is %@",error);
                switch (state) {
                    case SSDKResponseStateBegin:{   // 开始
                        NSLog(@"开始");
                        break;
                    }case SSDKResponseStateSuccess:{   // 分享成功
                        NSLog(@"成功");
                        [self showAlert:@"分享成功"];
                        break;
                    }case SSDKResponseStateFail:{      // 分享失败
                        NSLog(@"error is %@",error);
                        [self showAlert:@"分享失败"];
                        break;
                    }case SSDKResponseStateCancel:{     // 分享取消
                        [self showAlert:@"分享取消"];
                        break;
                    }
                    default:
                        break;
                }
            }
        ];}
    };
        
    popupController = [[CNPPopupController alloc] initWithContents:@[lineThreeLabel,lineOneLabel, imageView, lineTwoLabel, button,button1]];
    popupController.theme = [CNPPopupTheme defaultTheme];
    popupController.theme.popupStyle = popupStyle;
    popupController.delegate = self;
    [popupController presentPopupControllerAnimated:YES];
    
}

///将数据转换为二维码图片
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size{
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma AsyncScoket Delagate
/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"didConnectToHost:onSocket:%p didConnectToHost:%@ port:%hu",sock,host,port);

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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils showAlert:_SOCKET_CONNECT_FAIL];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self disconnect :clientSocket];
}

//断开连接
-(void) disconnect:(AsyncSocket *)sock
{
    //立即断开，任何未处理的读或写都将被丢弃
    //如果socket还没有断开，在这个方法返回之前，onSocketDidDisconnect 委托方法将会被立即调用
    //注意推荐释放AsyncSocket实例的方式：
    NSLog(@"device socket exit!!!");
    [sock setDelegate:nil];
    [sock disconnect];
    //[_clientSocket release];
    
}

#pragma end Delegate

- (void)timerFireMethod:(NSTimer*)theTimer{   //弹出框
    
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

//生成设备序号列表
- (NSMutableArray*) getDeviceName:(NSMutableArray*) devices{
    if (((unsigned long)devices.count)>0) {
        NSMutableArray *deviceLockNumberArray= [NSMutableArray new];
        //生成锁号列表
        for (NSDictionary *device in devices) {
            NSString *devicename  = [device objectForKey:@"devicename"];
            [deviceLockNumberArray addObject:devicename];
        }
        return deviceLockNumberArray;
    }
    return NULL;
}

//关闭软键盘
- (void)TapKeyBorad{
    [self.view endEditing:YES];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [visitnameTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createAdvertisement{
    NSArray *imageUrl = @[@"advertisement_3.jpg",@"advertisement_4.jpg"];
    for (int i = 0; i < 2; i++) {
        UIButton *advertisementBtn = [MyUtiles createBtnWithFrame:CGRectMake(10+((VIEW_WEIGHT-35)/2+15)*i,VIEW_HEIGTH- 3*((VIEW_WEIGHT-35)/2/5) -50-20 ,(VIEW_WEIGHT-35)/2,3*((VIEW_WEIGHT-35)/2/5)) title:nil normalBgImg:imageUrl[i] highlightedBgImg:imageUrl[i] target:self action:@selector(goAdvertisementDetailVc:)];
        advertisementBtn.tag = i+1000;
        [self .view addSubview:advertisementBtn];
    }
}

-(void)goAdvertisementDetailVc:(UIButton *)btn{
    
    NSInteger num = btn.tag - 1000;
    if (num == 0) {
        NSLog(@"第一个广告");
    }else if (num == 1){
        NSLog(@"第二个广告");
    }
}

-(void)creatLabel1{
    
    UILabel *label = [MyUtiles createLabelWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 30) font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter color:[UIColor lightGrayColor] text:@"智慧生活\t|\t你我共享"];
    [self.view addSubview:label];
    
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
