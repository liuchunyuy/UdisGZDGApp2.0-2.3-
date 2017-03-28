
#import "ServerSettingController.h"
//#import "DbUtil.h"

@interface ServerSettingController ()
{
    UILabel *signalLabel;
    UISegmentedControl *selectTypeSegment;
    UITextField *serverAddress;
    UIButton *confirm;
    DbUtil *dbUtil;
}

@end

//UIImageView *imageBgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height/4 + 10)];
//_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, imageBgV.bottom + 10, self.view.width, self.view.height - imageBgV.bottom - 80) style:UITableViewStylePlain];

@implementation ServerSettingController

- (id)initWithFrame:(CGRect)frame andSignal:(NSString *)szSignal
{
    self = [super init];
    if (self)
    {
        self.szSignal = szSignal;
        self.view.frame = frame;
        self.title = szSignal;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.view.layer.borderWidth = 1;
        self.view.layer.borderColor = [UIColor blueColor].CGColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  	// Do any additional setup after loading the view.
    
    //返回按钮
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn setFrame:CGRectMake(20, 40, 60, 30)];
    [backbtn setTitle:@"返回" forState:UIControlStateNormal];
    [backbtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [backbtn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    backbtn.layer.borderWidth = 1;
    backbtn.layer.borderColor = [UIColor blueColor].CGColor;
    backbtn.layer.masksToBounds = YES;
    backbtn.layer.cornerRadius = 6;
    [backbtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    
    //初始化服务器IP地址
    //UIImageView *imageBgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height/4 + 10)];
    //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, imageBgV.bottom + 10, self.view.width, self.view.height - imageBgV.bottom - 80) style:UITableViewStylePlain];
    //serverAddress = [[UITextField  alloc] initWithFrame: CGRectMake(20, 50, 280, 30)];
    //serverAddress = [[UITextField  alloc] initWithFrame: CGRectMake(20, CGRectGetHeight(self.view.frame)/2-150, 280, 30)];
    
    
    //服务器地址输入框
    serverAddress = [[UITextField  alloc] initWithFrame: CGRectMake(20, self.view.frame.size.height/2-150, self.view.frame.size.width-40, 30)];
    // This sets the border style of the text field
    serverAddress.borderStyle = UITextBorderStyleRoundedRect;
    serverAddress.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    [serverAddress setFont:[UIFont boldSystemFontOfSize:20]];
    serverAddress.placeholder = @"请输入服务器IP地址";
    //serverAddress.text=@"192.168.2.130";
    //textField.leftView = backbtn;
    //serverAddress.center=self.view.center;
    //It set when the left prefixLabel to be displayed
    //serverAddress.leftViewMode = UITextFieldViewModeAlways;
    
    //serverAddress.keyboardType=UIKeyboardTypeNumberPad;//存数字键盘
    serverAddress.keyboardType=UIKeyboardTypeNumbersAndPunctuation;//数字加键盘
    
    //获取服务器参数:Ipaddress、Port
    dbUtil =[[DbUtil alloc]init];
    sqlite3 *db=[dbUtil open];
    [dbUtil createTable:db];
    NSMutableArray *array=[dbUtil queryServerInfo];
    NSLog(@"record count=%lu",(unsigned long)array.count);
    ServerInfo *serverInfo=[[ServerInfo alloc]init];
    if (array) {
        //for (ServerInfo *serverInfo in array) {
        for (serverInfo in array) {
            NSLog(@"ConnectToSever:%@",serverInfo.ipaddress);
            NSLog(@"ConnectToSever:pid is %d",serverInfo.pid);
            NSLog(@"ConnectToSever:port is %d",serverInfo.port);
            //NSLog(@"ConnectToSever:ipaddress is %@",serverInfo.ipaddress);
            if (serverInfo) {//判断serverInfo是否有数据，如果有数据则退出循环
                break;
            }
        }
    }
    if (serverInfo) {
        serverAddress.text=serverInfo.ipaddress;
    }
    
    
    
    /*
    //避免软键盘遮挡
    serverAddress.tag=0;
    [serverAddress addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [serverAddress addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    */
    
    [self.view addSubview:serverAddress];
    // sets the delegate to the current class
    //serverAddress.delegate = self;
    
    
    //保存按钮
    confirm= [UIButton buttonWithType:UIButtonTypeCustom];
    //[confirm setFrame:CGRectMake(0, 0, 60, 30)];
    [confirm setFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-30, CGRectGetHeight(self.view.frame)/2-100, 60, 30)];
    [confirm setTitle:@"保存" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    confirm.layer.borderWidth = 1;
    confirm.layer.borderColor = [UIColor blueColor].CGColor;
    confirm.layer.masksToBounds = YES;
    confirm.layer.cornerRadius = 6;
    [confirm addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirm];

}

- (void)setSzSignal:(NSString *)szSignal
{
    _szSignal = szSignal;
    signalLabel.text = szSignal;
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)save:(id)sender
{

    if ([serverAddress.text isEqualToString:@""] || [serverAddress.text length]==0){//判断Ip地址是否为空
        NSLog(@"请输入服务器Ip地址");
        
         //UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"我的警告框" message:@"这是一个警告框" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"请输入服务器Ip地址" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        [self showAlert:@"请输入服务器Ip地址"];
        
        return ;
    }else{
        [self saveServerInfo];
    }
}


- (void) saveServerInfo{
    NSLog(@"save");    
    dbUtil =[[DbUtil alloc]init];
    sqlite3 *db=[dbUtil open];
    [dbUtil createTable:db];
    
    ServerInfo *serverInfo=[[ServerInfo alloc]init];
    serverInfo.ipaddress=serverAddress.text;
    serverInfo.port=90;
    //NSLog (@"server ipaddress is :%@",serverInfo.ipaddress);
    //NSLog(@"%@",serverInfo.ipaddress);
    //[dbUtil insertServerInfo:serverInfo];
    if ([dbUtil insertServerInfo:serverInfo]) {
        NSLog (@"save sucess");
        [self showAlert:@"保存成功"];
    } else {
        NSLog (@"save fail");
        [self showAlert:@"保存失败"];
    }
    
    /*
    //query
    NSMutableArray *array=[dbUtil queryServerInfo];
    NSLog(@"record count=%lu",(unsigned long)array.count);
    for (ServerInfo *serverInfo in array) {
        NSLog(@"%d",serverInfo.pid);
        NSLog(@"%@",serverInfo.ipaddress);
        //NSLog(@"%d,%@",serverInfo.pid,serverInfo.ipaddress);
    }
    */
    
}



//关闭软键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![serverAddress isExclusiveTouch]) {
        [serverAddress resignFirstResponder];
    }
}


- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
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

/*
//避免软键盘遮挡:进入编辑框
-(void)textFieldDidBeginEditing:(UITextField *)textField{   //开始编辑时，整体上移
    if (textField.tag==0) {
        [self moveView:-100];
    }
    
    if (textField.tag==1)
    {
        [self moveView:-60];
    }
    
}

//避免软键盘遮挡：退出编辑框
-(void)textFieldDidEndEditing:(UITextField *)textField{     //结束编辑时，整体下移
    if (textField.tag==0) {
        [self moveView:100];
    }
    
    if (textField.tag==1)
    {
        [self moveView:60];
    }
    
}
//避免软键盘遮挡：移动
-(void)moveView:(float)move{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    //frame.origin.x +=move;//view的X轴上移
    frame.origin.y +=move;//view的Y轴上移
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
}
*/




@end
