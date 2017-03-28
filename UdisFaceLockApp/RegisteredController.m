

#import "RegisteredController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MainAppViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "NewMessageController.h"
#import "PersonInfoController.h"
#import "HostServeViewController.h"
#import "MyUtiles.h"
//#import "SingletonSocket.h"
//@interface RegisteredController ()<EMChatManagerDelegate>
//@end

#define STOREAPPID @"1148486738"

@interface RegisteredController ()<UITextFieldDelegate, UIAlertViewDelegate,UIGestureRecognizerDelegate>{
    UITabBarController *_tabBarController;
    UIImageView *_backGroundImg;
    NSArray *messages;
}
@property(nonatomic,strong)NSString *versionStr;
@property(nonatomic,strong)NSString *totalmessage;
@property(nonatomic)BOOL isLogined;

@end

//@implementation RegisteredController
@implementation RegisteredController {
    MBProgressHUD *HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    //	HUD.delegate = self;
    HUD.labelText = @"登录中...";
    
    //添加self.view的点击事件（点击屏幕空白取消键盘）
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;

    _versionStr = [[NSString alloc]init];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0]];
    [self creatUserNameTextField];
    [self creatPassWordTextField];
    [self creatLogo];
    [self createVersonLabel];
    [self creatLoginBtn];
    [self creatLabel1];
}

-(void)creatLogo{
    
    UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-150)/2, 80, 150, 150)];
    logoImg.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImg];

}

-(void)createVersonLabel{

    NSString *versionStr1 = @"2.31";    //用户正在使用的版本-------代码的写死
    UILabel *versonLabel = [MyUtiles createLabelWithFrame:CGRectMake(3*(self.view.frame.size.width/4), self.view.frame.size.height-40, self.view.frame.size.width/4, 40) font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft color:[UIColor lightGrayColor] text:[NSString stringWithFormat:@"Version: %@",versionStr1]];
    [self.view addSubview:versonLabel];

    NSURL *url1 = [NSURL URLWithString:_VERSION_URL];
    NSURLRequest *urlR = [NSURLRequest requestWithURL:url1];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlR completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        _versionStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"更新后的版本 is %@",_versionStr);  //更新后的版本-------从服务器获取
        dispatch_async(dispatch_get_main_queue(), ^{
        if ([_versionStr floatValue] > [versionStr1 floatValue]) {
            NSString *message = [NSString stringWithFormat:@"有新版本(%@),请到AppStore更新",_versionStr];
            UIAlertView *alertUpdate = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            _versionStr = [[NSString alloc]init];
            NSLog(@"_versionStr 清零");
            NSLog(@"_versionStr清零后 is %@",_versionStr);
            [alertUpdate show];
        }else{
            _versionStr = [[NSString alloc]init];
            NSLog(@"_versionStr 清零");
            NSLog(@"_versionStr清零后 is %@",_versionStr);
            return ;
        }
        });
    }];
    [dataTask resume];
}

-(void)creatUserNameTextField{
    
    UILabel *nameLabel = [MyUtiles createLabelWithFrame:CGRectMake((self.view.frame.size.width-220)/2, self.view.frame.size.height/4+110, 60, 30) font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentCenter color:[UIColor blackColor] text:@"手机号:"];
    [self.view addSubview:nameLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, self.view.frame.size.height/4+140, 220, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    [self.view addSubview:lineView];
    
    _nameTextField = [MyUtiles createTextField:CGRectMake((self.view.frame.size.width-220)/2+60,self.view.frame.size.height/4+110 , 160, 30) placeholder:@" 请输入手机号" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor clearColor] keyboardType:UIKeyboardTypeNumbersAndPunctuation viewMode:UITextFieldViewModeAlways secureTextEntry:NO];
    [_nameTextField endEditing:YES];
    _nameTextField.returnKeyType = UIReturnKeyGo;
    _nameTextField.delegate = self;

    [self.view addSubview:_nameTextField];
    
    NSString *uname = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME1"];//默认上次的用户名
    NSLog(@"uname is %@", uname);
    if (uname == nil) {
        NSLog(@"没有保存过内容");
    }else{
        _nameTextField.text = uname;
    }
    [self.view endEditing:YES];
}

-(void)creatPassWordTextField{
    
    UILabel *passWordLabel = [MyUtiles createLabelWithFrame:CGRectMake((self.view.frame.size.width-220)/2, self.view.frame.size.height/3+110, 60, 30) font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentCenter color:[UIColor blackColor] text:@"密    码:"];
    [self.view addSubview:passWordLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, self.view.frame.size.height/3+140, 220, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    [self.view addSubview:lineView];
    
    _passwordTextField = [MyUtiles createTextField:CGRectMake((self.view.frame.size.width-220)/2+60,self.view.frame.size.height/3+110 , 160, 30) placeholder:@" 请输入密码" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor clearColor] keyboardType:UIKeyboardTypeNumbersAndPunctuation viewMode:UITextFieldViewModeAlways secureTextEntry:YES];
    [_passwordTextField endEditing:YES];
    _passwordTextField.returnKeyType = UIReturnKeyGo;
    _passwordTextField.delegate = self;
    [self.view addSubview:_passwordTextField];
    
    [self.view endEditing:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_nameTextField  resignFirstResponder];
    [_passwordTextField resignFirstResponder];

    [self LoginBtn:textField];
    return YES;
}

-(void)creatLoginBtn{
    
    UIButton *loginBtn = [MyUtiles createBtnWithFrame:CGRectMake((self.view.frame.size.width-220)/2, self.view.frame.size.height/3+180, 220, 30) title:@"登  录" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(LoginBtn:)];
    loginBtn.backgroundColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5;
    [loginBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [loginBtn.layer setBorderWidth:1];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //登录同时关闭键盘
    [_nameTextField endEditing:YES];
    [_passwordTextField endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LoginBtn:(id)sender{
     NSLog(@"click login button");
    
    NSString *str = _nameTextField.text;
    if (str.length > 0) {
        
        //Save the last user name
        [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"USERNAME1"];
        NSLog(@"str is %@", str);
    }
    if([_nameTextField.text isEqual:@""] || [_passwordTextField.text isEqual:@""]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"账号和密码不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        return;
    }
    
    // MBProgressHUD后台新建子线程执行任务
    //[HUD showWhileExecuting:@selector(login) onTarget:self withObject:nil animated:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_nameTextField endEditing:YES];
    [_passwordTextField endEditing:YES];
    
    if(clientSocket==nil){
        //[self ConnectToSever];//连接服务器
        if ( [self ConnectToSever]) {
            [self login];
        }
        
    }else{
        [self login];
    }
}

- (BOOL) ConnectToSever{
    if(clientSocket==nil)
    {
        clientSocket=[[AsyncSocket alloc] initWithDelegate:self];
        NSError *error=nil;
        NSString *address = [clientSocket getProperIPWithAddress:_SERVER_ADDRESS port:_SERVER_PORT];
        if(![clientSocket connectToHost:address onPort:_SERVER_PORT withTimeout:3 error:&error])
        {
            clientSocket = nil;
            return FALSE;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utils showAlert:@"连接服务器失败，请检查设置!!"];
        }
        else
        {
            NSLog(@"Connect sucess!");
            //[Utils showAlert:@"连接服务器成功!!"];
            _totalmessage = @"";
            return TRUE;
        }
        
    }else    {
        //_Status.text=@"已连接!";
        NSLog(@"Connected!");
        _totalmessage = @"";
        return TRUE;
    }
}

-(void)login{

    [self getData];
}

-(void)getData{

    //连接前，先手动断开
//    [[SingletonSocket sharedInstance] cutOffSocket];
//    [SingletonSocket sharedInstance].socket.userData = SocketOfflineByUser;
//    
//    [[SingletonSocket sharedInstance] startConnectSocket];
    
    NSDictionary *parmDictionary= [NSDictionary dictionaryWithObjectsAndKeys:_nameTextField.text,@"user",
                                   _passwordTextField.text,@"password",
                                   @"",@"cardnumber",
                                   @"",@"visitmobil",
                                   @"",@"visitname",
                                   @"",@"deviceid",
                                   @"",@"newpassword",
                                   @"",@"messageID",nil];
    NSDictionary *jsonDictionary=[NSDictionary dictionaryWithObjectsAndKeys:@"Login",@"command",
                                  parmDictionary,@"parameter",nil];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    NSString * inputMsgStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * content = [[_MESSAGE_START stringByAppendingString:inputMsgStr] stringByAppendingString:_MESSAGE_END];
    NSLog(@"send action is: %@",content);
    NSData *sendata = [content dataUsingEncoding:NSISOLatin1StringEncoding];
    [clientSocket writeData:sendata withTimeout:20 tag:0];
    self.isLogined = NO;
    [self performSelector:@selector(checkIsLogined) withObject:nil afterDelay:20];
    //[[SingletonSocket sharedInstance] getSocketData:jsonDictionary]; //发送数据
    //self.isLogined = NO;
    //[self performSelector:@selector(checkIsLogined) withObject:nil afterDelay:20];
    
}    //block 接收请求到的数据dic并解析

//接收数据
-(void)receiveData :(NSData *)data{
//    [[SingletonSocket sharedInstance]returnDictionary:^(NSDictionary *dic) {
//        // blockdic = dic;
//        NSLog(@"dic is %@",dic);
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
                NSLog(@"--------needmessage is: %@",needmessage);
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[needmessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                // totalmessage=@"";
                NSLog(@"dic=%@",dic);
                if([dic objectForKey:@"command"]){// Node containing the command
                    NSString *command=[dic objectForKey:@"command"];
                    NSLog(@"command is: %@",command);
                    if ([command isEqual:@"Login"]) {
                        NSLog(@"Login!!!!");
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if([dic objectForKey:@"code"]){
                            NSString *code=[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
                            NSLog(@"code is: %@",code);
                            messages = [dic objectForKey:@"messages"];
                            NSMutableArray *arr = [NSMutableArray arrayWithArray:messages];
                            // NSLog(@"messages is %@", messages);
                            if (messages.count == 0) {
                                //return;
                            }else{
                                NSDictionary *messageDic = messages[0];
                                NSString *message = [messageDic objectForKey:@"message"];
                                // NSLog(@"message is %@", message);
                                [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"message"];
                            }
                            
                            if ([code isEqual:@"1"]) {
                                [Utils showAlert:@"亲，用户不存在!!"];
                            }
                            if ([code isEqual:@"2"]) {
                                [Utils showAlert:@"亲，密码错误!!"];
                            }
                            if ([code isEqual:@"3"]) {
                                [Utils showAlert:@"亲，系统异常!!"];
                            }
                            
                            if ([code isEqual:@"0"]) {
                                
                                if([dic objectForKey:@"devices"]){
                                    NSArray *deviceDicarray = [dic objectForKey:@"devices"];
                                    //添加设备：
                                    [[NSUserDefaults standardUserDefaults] setObject:deviceDicarray forKey:@"devices"];
                                }
                                if([dic objectForKey:@"userinfo"]){
                                    NSDictionary *userInfo = [dic objectForKey:@"userinfo"];
                                    NSString *user = [userInfo objectForKey:@"user"];
                                    NSString *username  = [userInfo objectForKey:@"username"];
                                    //NSString *address  = [userInfo objectForKey:@"address"];
                                    NSLog(@"user=%@, username=%@", user, username);
                                    
                                    //添加用户信息
                                    [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
                                    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
                                    NSString *password=_passwordTextField.text;
                                    [[NSUserDefaults standardUserDefaults] setObject: password forKey:@"password"];
                                }
                                //加载主页面
                                NSMutableArray *VcArr = [[NSMutableArray alloc]init];
                                _tabBarController = [[UITabBarController alloc]init];
                                
                                MainAppViewController *mainVc = [[MainAppViewController alloc]init];
                                mainVc.title = @"主要服务";
                                mainVc.noticeMessages = messages;
                                UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:mainVc];
                                
                                NewMessageController *newMessageVc = [[NewMessageController alloc]init];
                                newMessageVc.title = @"最新消息";
                                UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:newMessageVc];
                                
                                PersonInfoController *personInfoVc = [[PersonInfoController alloc]init];
                                personInfoVc.title = @"个人中心";
                                UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:personInfoVc];
                                [VcArr addObject:nav1];
                                [VcArr addObject:nav2];
                                [VcArr addObject:nav4];
                                _tabBarController.viewControllers = VcArr;
                                NSArray *imageArray = @[@"主要@2x",@"最新@2x",@"个人@2x"];
                                for (int i = 0; i < imageArray.count; i++) {
                                    UITabBarItem *item = _tabBarController.tabBar.items[i];
                                    [item setImage:[UIImage imageNamed:imageArray[i]]];
                                }
                                [self presentViewController:_tabBarController animated:YES completion:^{
                                    
                                    newMessageVc.messagesArr = arr;
                                    
                                }];
                            }
                        }
                    }
                }
            }
        }
    }
}

-(void)checkIsLogined{
    if (self.isLogined) {
        //已经登录
    }else{
        //未登录
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showAlert:@"系统忙，稍候再试 "];
       // [SingletonSocket sharedInstance].socket = nil;
    }
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.nameTextField resignFirstResponder];
}

// Pop-up box
- (void)timerFireMethod:(NSTimer*)theTimer{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{// time
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

#pragma AsyncScoket Delagate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"didConnectToHost:onSocket:%p didConnectToHost:%@ port:%hu",sock,host,port);
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"didWriteDataWithTag");
    [sock readDataWithTimeout: -1 tag: 0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"didReadData");
    self.isLogined = YES;
    
    NSLog(@"data is: %@",data);
    [self receiveData:data];
    [sock readDataWithTimeout:-1 tag:0];
}


- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag
{
    NSLog(@"onSocket:%p didSecure:YES", sock);
}


- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
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
#pragma end Delegate


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

-(void)creatLabel1{
    
    UILabel *label = [MyUtiles createLabelWithFrame:CGRectMake((self.view.frame.size.width-150)/2, self.view.frame.size.height-100, 60, 30) font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter color:[UIColor lightGrayColor] text:@"智慧生活"];
    [self.view addSubview:label];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-150)/2+75, self.view.frame.size.height-92.5, 1, 15)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    UILabel *label1 = [MyUtiles createLabelWithFrame:CGRectMake((self.view.frame.size.width-150)/2+90, self.view.frame.size.height-100, 60, 30) font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter color:[UIColor lightGrayColor] text:@"你我共享"];
    [self.view addSubview:label1];
    
}

@end
