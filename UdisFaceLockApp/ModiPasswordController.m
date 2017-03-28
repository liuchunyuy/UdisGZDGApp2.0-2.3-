
#import "ModiPasswordController.h"
//#import "DbUtil.h"
#import "MyUtiles.h"
#import "SingletonSocket.h"

@interface ModiPasswordController ()<UIGestureRecognizerDelegate>{
    
    UILabel *signalLabel;
    UISegmentedControl *selectTypeSegment;
    UITextField *oldPassword;
    UITextField *newPassword;
    UITextField *passwordAgain;
    UIButton *confirm;
    NSDictionary *jsonDictionary;
    //DbUtil *dbUtil;
}
@property(nonatomic)BOOL isLogined;

@end


@implementation ModiPasswordController

- (id)initWithFrame:(CGRect)frame andSignal:(NSString *)szSignal{
    
    self = [super init];
    if (self){
        
        self.szSignal = szSignal;
        self.view.frame = frame;
        self.title = szSignal;
        [self.view setBackgroundColor:[UIColor clearColor]];
        //self.view.layer.borderWidth = 1;
       // self.view.layer.borderColor = [UIColor blueColor].CGColor;
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
  	// Do any additional setup after loading the view.
    //self.view.backgroundColor  =[UIColor whiteColor];
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    jsonDictionary = [[NSDictionary alloc]init];
    UILabel *oldLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 100, 60, 30)];
    oldLabel.font  = [UIFont systemFontOfSize:16];
    oldLabel.textAlignment = NSTextAlignmentCenter;
    oldLabel.textColor = [UIColor blackColor];
    oldLabel.text = @"旧密码:";
    [self.view addSubview:oldLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 130, 220, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    
    oldPassword = [MyUtiles createTextField:CGRectMake((self.view.frame.size.width-220)/2+60,100, 160, 30) placeholder:@" 请输入旧密码" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor clearColor] keyboardType:UIKeyboardTypeNumbersAndPunctuation viewMode:UITextFieldViewModeAlways secureTextEntry:YES];
    [oldPassword setFont:[UIFont boldSystemFontOfSize:15]];
    [oldPassword endEditing:YES];
    [self.view addSubview:oldPassword];
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 150, 60, 30)];
    newLabel.font  = [UIFont systemFontOfSize:16];
    newLabel.textAlignment = NSTextAlignmentCenter;
    newLabel.textColor = [UIColor blackColor];
    newLabel.text = @"新密码:";
    [self.view addSubview:newLabel];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2,180, 220, 1)];
    lineView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView1];
    
    newPassword = [MyUtiles createTextField:CGRectMake((self.view.frame.size.width-220)/2+60, 150, 160, 30) placeholder:@" 请输入新密码" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor clearColor] keyboardType:UIKeyboardTypeNumbersAndPunctuation viewMode:UITextFieldViewModeAlways secureTextEntry:YES];
    [newPassword setFont:[UIFont boldSystemFontOfSize:15]];
    [newPassword endEditing:YES];
    [self.view addSubview:newPassword];
    
    UILabel *againLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 200, 60, 30)];
    againLabel.font  = [UIFont systemFontOfSize:16];
    againLabel.textAlignment = NSTextAlignmentCenter;
    againLabel.textColor = [UIColor blackColor];
    againLabel.text = @"新密码:";
    [self.view addSubview:againLabel];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 230, 220, 1)];
    lineView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView2];
    
    passwordAgain = [MyUtiles createTextField:CGRectMake((self.view.frame.size.width-220)/2+60,200 , 160, 30) placeholder:@" 请再次输入新密码" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor clearColor] keyboardType:UIKeyboardTypeNumbersAndPunctuation viewMode:UITextFieldViewModeAlways secureTextEntry:YES];
    [passwordAgain setFont:[UIFont boldSystemFontOfSize:15]];
    [passwordAgain endEditing:YES];
    [self.view addSubview:passwordAgain];

    //保存按钮
    confirm= [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setFrame:CGRectMake((self.view.frame.size.width-220)/2,300, 220, 30)];
    [confirm setTitle:@"保存" forState:UIControlStateNormal];
    confirm.backgroundColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    confirm.layer.cornerRadius = 5;
    confirm.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirm addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirm];

    //关闭软键盘使用
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;

}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [oldPassword resignFirstResponder];
}

- (void)setSzSignal:(NSString *)szSignal{
    
    _szSignal = szSignal;
    signalLabel.text = szSignal;
}

- (void)backAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(id)sender{
    
    [passwordAgain endEditing:YES];
    [newPassword endEditing:YES];
    [oldPassword endEditing:YES]; //保存同时关闭键盘
    
    if([oldPassword.text isEqual:@""] ){
        [Utils showAlert:@"旧密码不能为空!"];
        return;
    }
    
    if(![oldPassword.text isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]] ){
        [Utils showAlert:@"旧密码输入有误!"];
        return;
    }
    
    if([newPassword.text isEqual:@""] ){
        [Utils showAlert:@"新密码不能为空!"];
        return;
    }
    
    if (newPassword.text.length < 6 ) {
        [Utils showAlert:@"新密码至少6位!"];
        return;
    }
        
    if(![newPassword.text isEqual:passwordAgain.text] ){
        [Utils showAlert:@"两次输入的密码必须一致!"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self getData];
}

-(void)getData{
    
    NSLog(@"sendModiPasswordData!");
    NSString *user=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    NSLog(@"user is %@",user);
    //开始拼接Json字符串
    NSDictionary *parmDictionary= [NSDictionary dictionaryWithObjectsAndKeys:user,@"user",
                                   oldPassword.text,@"password",
                                   @"",@"cardnumber",
                                   @"",@"visitmobil",
                                   @"",@"visitname",
                                   @"",@"deviceid",
                                   newPassword.text,@"newpassword",
                                   @"",@"messageID",nil];
    jsonDictionary=[NSDictionary dictionaryWithObjectsAndKeys:@"ModiPassword",@"command",
                                  parmDictionary,@"parameter",nil];

    //连接前，先手动断开
    [[SingletonSocket sharedInstance] cutOffSocket];
    [SingletonSocket sharedInstance].socket.userData = SocketOfflineByServer;
    //连接服务器并发送数据
    [[SingletonSocket sharedInstance] getSocketData:jsonDictionary];
    
    [self reviceData];

}

-(void)reviceData{
    
    [[SingletonSocket sharedInstance]returnDictionary:^(NSDictionary *dic) {
        //NSLog(@"修改密码dic ---2 %@",dic);
        if([dic objectForKey:@"command"]){//含有command 节点
            NSString *command=[dic objectForKey:@"command"];
            NSLog(@"command is: %@",command);
            if ([command isEqual:@"ModiPassword"]) {
                NSLog(@"ModiPassword!!!!");
                if([dic objectForKey:@"code"]){
                    NSString *code=[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
                    NSLog(@"code is: %@",code);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if ([code isEqual:@"0"]) {
                        [[NSUserDefaults standardUserDefaults] setObject: newPassword.text forKey:@"password"];
                        [Utils showAlert:@"密码修改成功!"];
                    }
                    if ([code isEqual:@"1"]) {
                        [Utils showAlert:@"用户不存在，请联系管理员!"];
                    }
                    if ([code isEqual:@"2"]) {
                        [Utils showAlert:@"旧口令错误!"];
                    }
                    if ([code isEqual:@"3"]) {
                        [Utils showAlert:@"系统异常，请重新修改!"];
                    }
                }
            }
        }
        
    }];
}

#pragma end Delegate

- (void)viewWillDisappear:(BOOL)animated{
    [self disconnect :[SingletonSocket sharedInstance].socket];
}

//断开连接
-(void) disconnect:(AsyncSocket *)sock{
    
    //立即断开，任何未处理的读或写都将被丢弃
    //如果socket还没有断开，在这个方法返回之前，onSocketDidDisconnect 委托方法将会被立即调用
    //注意推荐释放AsyncSocket实例的方式：
    NSLog(@"device socket exit!!!");
    [sock setDelegate:nil];
    [sock disconnect];
    //[_clientSocket release];
    
}

//关闭软键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![oldPassword isExclusiveTouch]) {
        [oldPassword resignFirstResponder];
    }
}

- (void)timerFireMethod:(NSTimer*)theTimer{ //弹出框

    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

@end
