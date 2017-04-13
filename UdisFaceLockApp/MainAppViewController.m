

#import "MainAppViewController.h"
#import "SubViewController.h"
#import "TouchPropagatedScrollView.h"
#import "Config.h"
#import "MBProgressHUD.h"
#import "SZKRoundScrollView.h"
#import "MyUtiles.h"
#import "OpenLockViewController.h"
#import "QRCodeViewController.h"
#import "NewMessageController.h"
#import "HostServeViewController.h"
//#import "SportsViewController.h"
#import "NewsViewController.h"
#import "WeChatViewController.h"
#import "LongDistanceBusViewController.h"
#import "PublicTransportViewController.h"
#import "IdiomDictionaryViewController.h"
#import "TVShowViewController.h"
#import "SportsNewsViewController.h"
#import "EspressViewController.h"   //快递

#import "GYZChooseCityController.h"   //城市选择
#import <CoreLocation/CoreLocation.h>


#define MENU_HEIGHT 36
#define MENU_BUTTON_WIDTH  100
#define MIN_MENU_FONT  13.f
#define MAX_MENU_FONT  18.f
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width //轮播宽
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height //轮播高

#define VIEW_HEIGTH self.view.frame.size.height
#define VIEW_WEIGHT self.view.frame.size.width

NSString *totalmessage=@"";

@interface MainAppViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,GYZChooseCityDelegate>{
    NSString * currentCity; //当前城市
    NSUInteger number;
    UIButton *cityBtn;
}
@property (strong,nonatomic) CLLocationManager * locationManager;
@property(nonatomic,copy)SZKRoundScrollView *roundScrollView;
@property(nonatomic,copy)UIAlertView *noticeAlertView;
@property(nonatomic,strong)NSString *noticeMessageStr;
@property(nonatomic,copy)NSMutableArray *messageArr; // 公告消息message数组
@property(nonatomic,copy)NSMutableArray *titleArr; // 公告消息标题数组
@property(nonatomic,copy)NSMutableArray *datetimeArr; // 公告消息日期数组
@property(nonatomic,strong)NSString *messageStr;     //公告消息message+datetime数组
@property(nonatomic,copy)UIScrollView *buttonScrollView;
@property(nonatomic,copy)NSArray *localImageArr;
@property(nonatomic,copy)NSMutableArray *netImageArr;
@property(nonatomic,copy)NSDictionary *weatherDic;

@end

@implementation MainAppViewController

////本地图片
//-(NSArray *)localImageArr{
//    
//    _localImageArr=@[@"mv_00",@"mv_01",@"mv_02"];
//    //轮播图图片数组
//    return _localImageArr;
//}

- (void)viewDidLoad{
    
    UIView *statusBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 0.f)];
    if (isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1){
        
        statusBarView.frame = CGRectMake(statusBarView.frame.origin.x, statusBarView.frame.origin.y, statusBarView.frame.size.width, 20.f);
        statusBarView.backgroundColor = [UIColor clearColor];
        ((UIImageView *)statusBarView).backgroundColor = [UIColor clearColor];
        [self.view addSubview:statusBarView];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.extendedLayoutIncludesOpaqueBars = YES;// 延伸导航栏至（0.0）
    //设置导航的背景色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationItem.title = @"";
    //关闭软键盘使用
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    [super viewDidLoad];
    
    //按钮
    _buttonScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+(VIEW_HEIGTH-64-49)/3, VIEW_WEIGHT, VIEW_HEIGTH-64-49- (VIEW_HEIGTH-64-49)/3)];
    _buttonScrollView.contentSize = CGSizeMake(VIEW_WEIGHT, 60+VIEW_WEIGHT-20+VIEW_WEIGHT/3);
    _buttonScrollView.showsHorizontalScrollIndicator = NO;
    _buttonScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_buttonScrollView];
    
    //self.navigationController.delegate = self; //实现nav代理隐藏本页面的nav
    [self creatAlertView];  //公告提示框
  //  [self weather];
    [self creatBtnView];
    [self netImageArr];
    
}

-(void)creatAlertView{

    _messageArr = [NSMutableArray array];
    _titleArr = [NSMutableArray array];
    _datetimeArr = [NSMutableArray array];
    NSLog(@"_noticeMessages is %@",_noticeMessages);
    for (NSDictionary *dic in _noticeMessages) {
        NSString *message = [dic objectForKey:@"message"];
        NSString *title = [dic objectForKey:@"messageTitle"];
        NSString *datatime = [dic objectForKey:@"datetime"];
       // NSLog(@"message is %@",message);
        [_messageArr addObject:message];        
        [_titleArr addObject:title];
        [_datetimeArr addObject:datatime];
    }
   // NSLog(@"_arr is %@",_messageArr);
    if (_messageArr.count == 0) {
        return;
    }
    number = 0;
    _messageStr = [NSString stringWithFormat:@"%@\n截止日期: %@",_messageArr[number],_datetimeArr[number]];
    _noticeAlertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@ (%lu/%lu)",_titleArr[number],(unsigned long)(number+1),(unsigned long)_titleArr.count] message:_messageStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"上一页",@"下一页" , nil];
    [_noticeAlertView show];
    [self dismissAlertView];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        NSLog(@"上一页");
        if (number == 0) {
            _messageStr = [NSString stringWithFormat:@"%@\n截止日期: %@",_messageArr[number],_datetimeArr[number]];
            _noticeAlertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@ (%lu/%lu)",_titleArr[number],(unsigned long)(number+1),(unsigned long)_titleArr.count] message:_messageStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"上一页",@"下一页" , nil];
            [_noticeAlertView show];
            [self dismissAlertView];
            return;
        }
        number--;
        _messageStr = [NSString stringWithFormat:@"%@\n截止日期: %@",_messageArr[number],_datetimeArr[number]];
        _noticeAlertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@ (%lu/%lu)",_titleArr[number],(unsigned long)(number+1),(unsigned long)_titleArr.count] message:_messageStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"上一页",@"下一页" , nil];
        [_noticeAlertView show];
        [self dismissAlertView];
    }else if (buttonIndex == 1){
        NSLog(@"下一页");
        _messageStr = [NSString stringWithFormat:@"%@\n截止日期: %@",_messageArr[number],_datetimeArr[number]];
        if (number == _titleArr.count-1) {
            _noticeAlertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@ (%lu/%lu)",_titleArr[number],(unsigned long)(number+1),(unsigned long)_titleArr.count] message:_messageStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"上一页",nil , nil];
            [_noticeAlertView show];
            [self dismissAlertView];
            return;
        }
        number++;
        _messageStr = [NSString stringWithFormat:@"%@\n截止日期: %@",_messageArr[number],_datetimeArr[number]];
        _noticeAlertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@ (%lu/%lu)",_titleArr[number],(unsigned long)(number+1),(unsigned long)_titleArr.count] message:_messageStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"上一页",@"下一页" , nil];
        [_noticeAlertView show];
        [self dismissAlertView];

    }
}

//点空白alertview消失
-(void)dismissAlertView{

    UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizerTap setNumberOfTapsRequired:1];
    recognizerTap.cancelsTouchesInView = NO;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:recognizerTap];
}
//点击空白alertview消失
- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![_noticeAlertView pointInside:[_noticeAlertView convertPoint:location fromView:_noticeAlertView.window] withEvent:nil]){
            [_noticeAlertView.window removeGestureRecognizer:sender];
            [_noticeAlertView dismissWithClickedButtonIndex:0 animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"公告内容也可以去主页中【最新消息】页面查看。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }  
    }  
}

-(void)weather{

    //判断定位服务是否打开
    if(![CLLocationManager locationServicesEnabled]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位服务未打开" preferredStyle:UIAlertControllerStyleAlert];
        //创建按钮
        //handler:点击按钮执行的事件
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    self.locationManager = [[CLLocationManager alloc]init];
    //iOS8之后需要请求权限
    //判断当前手机系统是否高于8.0
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0){
        //请求使用期间访问位置信息权限
        [self.locationManager requestWhenInUseAuthorization];
        //请求一直访问位置信息权限
        //[locationManager requestAlwaysAuthorization];
    }
    //定位精度 kCLLocationAccuracyBest：最精确
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //多少米之外去更新用户位置
    //locationManager.distanceFilter = 100;
    //设置代理
    self.locationManager.delegate = self;
    //开始定位
    [self.locationManager startUpdatingLocation];
    NSLog(@"开始定位");
    
}

//网络图片
-(NSArray *)netImageArr{
    
    _netImageArr = [NSMutableArray array];
    NSURL *url1 = [NSURL URLWithString:_SCROOLVIEW_IMAGE_URL];
    NSURLRequest *urlR = [NSURLRequest requestWithURL:url1];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlR completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *rec = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (rec == nil) {
            return ;
        }
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[rec dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        //回到主线程刷新页面
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (NSDictionary *dic1 in dic) {
                NSString *imgUrl =  [dic1 objectForKey:@"imgUrl"];
                [_netImageArr addObject:imgUrl];
            }
            if (_netImageArr.count == 0) {
                return ;
            }
            //展示图
            _roundScrollView=[SZKRoundScrollView roundScrollViewWithFrame:CGRectMake(0, 64, VIEW_WEIGHT, (VIEW_HEIGTH-64-49)/3) imageArr:_netImageArr timerWithTimeInterval:2 imageClick:^(NSInteger imageIndex) {
                NSLog(@"imageIndex:第%ld个",(long)imageIndex);
            }];
            [self.view addSubview:_roundScrollView];
        });
        
        //小圆点控制器位置
        _roundScrollView.pageControlAlignment=NSPageControlAlignmentCenter;
        //当前小圆点颜色
        _roundScrollView.curPageControlColor=[UIColor yellowColor];
        //其余小圆点颜色
        _roundScrollView.otherPageControlColor=[UIColor orangeColor];
        
    }];
    [dataTask resume];    
    return _netImageArr;
}

-(void)creatBtnView{
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(2, 0, 4, 30)];
    view1.backgroundColor = [UIColor redColor];
    [_buttonScrollView addSubview:view1];
    
    UILabel *titleLable1 = [MyUtiles createLabelWithFrame:CGRectMake(12, 0, 200, 30) font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft color:[UIColor grayColor] text:@"主要功能"];
    [_buttonScrollView addSubview:titleLable1];

    //开门按钮
    UIButton *openBtn = [MyUtiles createBtnWithFrame:CGRectMake(30, 30 +10, VIEW_WEIGHT/2-60, VIEW_WEIGHT/3-20 -20) title:@"开  门" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(goOpenView)];
    openBtn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:240.0/255.0 blue:245.0/255.0 alpha:1.0];
    openBtn.layer.masksToBounds = YES;
    openBtn.layer.cornerRadius = 25;
    [openBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [openBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [openBtn setImage:[UIImage imageNamed:@"开门@2x"] forState:UIControlStateNormal];
    openBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self initButton:openBtn];
    
    [_buttonScrollView addSubview:openBtn];
    
    //二维码按钮
    UIButton *qrCodeBtn = [MyUtiles createBtnWithFrame:CGRectMake(VIEW_WEIGHT/2 +30, 30+10, VIEW_WEIGHT/2-60, VIEW_WEIGHT/3-20-20) title:@"二维码" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(goQRCodeView)];
    qrCodeBtn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:240.0/255.0 blue:245.0/255.0 alpha:1.0];
    qrCodeBtn.layer.masksToBounds = YES;
    qrCodeBtn.layer.cornerRadius = 25;
    [qrCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [qrCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [qrCodeBtn setImage:[UIImage imageNamed:@"二维码@2x"] forState:UIControlStateNormal];
    qrCodeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self initButton:qrCodeBtn];
    
    [_buttonScrollView addSubview:qrCodeBtn];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(2, 30+VIEW_WEIGHT/3-20, 4, 30)];
    view2.backgroundColor = [UIColor purpleColor];
    [_buttonScrollView addSubview:view2];
    
    UILabel *titleLable2 = [MyUtiles createLabelWithFrame:CGRectMake(12, 30+VIEW_WEIGHT/3-20, 200, 30) font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft color:[UIColor grayColor] text:@"便捷功能"];
    [_buttonScrollView addSubview:titleLable2];
    
    //九宫格按钮
    for (int i = 0; i < 9; i ++) {
        CGFloat n = i % 3 * (VIEW_WEIGHT/3);
        CGFloat m =VIEW_WEIGHT/3-20 + i / 3 * (VIEW_WEIGHT/3);
        UIButton * bun = [UIButton buttonWithType:UIButtonTypeCustom];
        NSArray *nameArr = @[@"快递查询",@"便民热线",@"新闻头条",@"微信精选",@"长途汽车",@"公交换乘",@"成语词典",@"体育资讯",@"电视节目"];
        //https://www.wenlong.org/kuaidi/   快递
        if (i >= 2) {
            [bun setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [bun setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        }else{
            [bun setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [bun setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        }
        bun.frame = CGRectMake(n, m+60, VIEW_WEIGHT/3, VIEW_WEIGHT/3);
       // [bun setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       // [bun setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [bun setTitle:nameArr[i] forState:UIControlStateNormal];
        bun.titleLabel.font = [UIFont systemFontOfSize:16];
        bun.layer.borderColor = [[UIColor colorWithRed:176.0/255.0 green:224.0/255.0 blue:230.0/255.0 alpha:1.0] CGColor];
        bun.layer.borderWidth = 1.0f;
        bun.layer.masksToBounds = YES;
        //bun.layer.cornerRadius = 30;
        //设置按钮上字体的位置（四个参数表示距离上边界，左边界，下边界，右边界，默认都为0）
        bun.titleLabel.font = [UIFont systemFontOfSize:15];
        NSArray *iconImg = @[@"运动健身@2x",@"旅游@2x",@"小区咨讯@2x",@"其他1@2x",@"交通2@2x",@"公交换乘@2x",@"成语词典@2x",@"体育资讯@2x",@"电视节目@2x"];
        [bun setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",iconImg[i]]] forState:UIControlStateNormal];
        [bun.imageView setContentMode:UIViewContentModeScaleToFill];
        [self initButton:bun];
        bun.tag = i + 1000;
        [bun addTarget:self action:@selector(buttonSix:) forControlEvents:UIControlEventTouchUpInside];
       //[self.view addSubview:bun];
        [_buttonScrollView addSubview:bun];
    }
}

//封装调整button上文字和图片居中，且图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height+10 ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-30, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

-(void)buttonSix:(UIButton *)btn{

    NSInteger num = btn.tag - 1000;
        NSLog(@"点击第%ld个按钮",(long)num);
    if (num == 1) {
        //进入便民热线
       // [self showAlert:@"功能建设中..."];
       // return;
        self.hidesBottomBarWhenPushed = YES;
        HostServeViewController *hostServeVc = [[HostServeViewController alloc]init];
        [self.navigationController pushViewController:hostServeVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if (num == 0){
        //进入快递
        //[self showAlert:@"功能建设中..."];
        //return;
        self.hidesBottomBarWhenPushed = YES;
        EspressViewController *sportsVc = [[EspressViewController alloc]init];
        [self.navigationController pushViewController:sportsVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if(num == 2){
        //进入新闻头条
        [self showAlert:@"功能建设中..."];
        return;
        self.hidesBottomBarWhenPushed = YES;
        NewsViewController *newsVc = [[NewsViewController alloc]init];
        [self.navigationController pushViewController:newsVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if(num == 3){
        //进入微信精选
       // [self showAlert:@"功能建设中..."];
       // return;
        self.hidesBottomBarWhenPushed = YES;
        WeChatViewController *weChatVc = [[WeChatViewController alloc]init];
        [self.navigationController pushViewController:weChatVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if(num == 4){
        //进入长途汽车
        [self showAlert:@"功能建设中..."];
        return;
        self.hidesBottomBarWhenPushed = YES;
        LongDistanceBusViewController *longDistanceBusVc = [[LongDistanceBusViewController alloc]init];
        [self.navigationController pushViewController:longDistanceBusVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if(num == 5){
        //进入公交换乘
        [self showAlert:@"功能建设中..."];
        return;
        self.hidesBottomBarWhenPushed = YES;
        PublicTransportViewController *publicTransportVc = [[PublicTransportViewController alloc]init];
        [self.navigationController pushViewController:publicTransportVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if(num == 6){
        //进入成语字典
        [self showAlert:@"功能建设中..."];
        return;
        self.hidesBottomBarWhenPushed = YES;
        IdiomDictionaryViewController *idiomDictionaryVc = [[IdiomDictionaryViewController alloc]init];
        [self.navigationController pushViewController:idiomDictionaryVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if(num == 7){
        //进入体育资讯
        [self showAlert:@"功能建设中..."];
        return;
        self.hidesBottomBarWhenPushed = YES;
        SportsNewsViewController *sportsNewsVc = [[SportsNewsViewController alloc]init];
        [self.navigationController pushViewController:sportsNewsVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
        //进入电视节目
        [self showAlert:@"功能建设中..."];
        return;
        self.hidesBottomBarWhenPushed = YES;
        TVShowViewController *TVShowVc = [[TVShowViewController alloc]init];
        [self.navigationController pushViewController:TVShowVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

-(void)goOpenView{

    self.hidesBottomBarWhenPushed = YES;
    OpenLockViewController *OLVc = [[OpenLockViewController alloc]init];
    [self.navigationController pushViewController:OLVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)goQRCodeView{

    self.hidesBottomBarWhenPushed = YES;
    QRCodeViewController *QRCVc = [[QRCodeViewController alloc]init];
    [self.navigationController pushViewController:QRCVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//定位失败则执行此代理方法
//定位失败弹出提示框,点击"打开定位"按钮,会打开系统的设置,提示打开定位服务
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"定位失败");
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位，才能获取天气信息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开定位设置
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"定位成功");
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            NSLog(@"%@",currentCity); //这就是当前的城市
            NSLog(@"%@",placeMark.name);//具体地址:  xx市xx区xx街道
    
            [self getWeatherData];
           
        }
        else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
    }];        
}

-(void)getWeatherData{

    NSString *url = [NSString stringWithFormat:@"https://v.juhe.cn/weather/index?format=2&cityname=%@&key=4d6eeb87175561802e67bc8db4308c91",currentCity];
    // NSString *url = [NSString stringWithFormat:@"https://api.seniverse.com/v3/weather/now.json?key=xkuzbo0m3clihjag&location=%@&language=zh-Hans&unit=c",currentCity];
    // NSString *url = @"https://api.seniverse.com/v3/weather/now.json?key=xkuzbo0m3clihjag&location=beijing&language=zh-Hans&unit=c";
    NSString *str = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url1 = [NSURL URLWithString:str];
    NSURLRequest *urlR = [NSURLRequest requestWithURL:url1];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlR completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *rec = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[rec dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"weather dic is %@", dic);
        
        if(![[dic objectForKey:@"reason"] isEqualToString: @"successed!"]){
            NSLog(@"code %@ reason %@",[dic objectForKey:@"error_code"],[dic objectForKey:@"reason"]);
            return ;
        }

        NSDictionary *resultDic = [dic objectForKey:@"result"];
         NSLog(@"resultDic is %@",resultDic);

        NSDictionary *dataDic = [resultDic objectForKey:@"today"];
        // NSLog(@"dataArr is %@",dataDic);
        //NSArray *weatherArr = [dataDic objectForKey:@"weather"];
        // NSLog(@"weather is %@", weatherDic);
        //回到主线程刷新页面
        dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"weatherDic is %@");
            // NSLog(@"weatherArr[0] is %@",weatherArr[0]);
            NSLog(@"地点:%@",currentCity);
            NSString *date = [dataDic objectForKey:@"date_y"]; //日期
            NSString *temperature = [dataDic objectForKey:@"temperature"]; // 温度
            NSString *weather = [dataDic objectForKey:@"weather"];// 天气
            NSString *wind = [dataDic objectForKey:@"wind"];     // 风力
            NSString *week = [dataDic objectForKey:@"week"];     //星期
            NSString *dressing_advice = [dataDic objectForKey:@"dressing_advice"];// 建议穿着
            
            UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, 64)];
            self.navigationItem.titleView = navView;
            
            // 城市
            cityBtn = [MyUtiles createBtnWithFrame:CGRectMake(0, 22, 80, 20) title:[NSString stringWithFormat:@"%@", currentCity] normalBgImg:nil highlightedBgImg:nil target:self action:@selector(location)];
            [cityBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [cityBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [cityBtn setImage:[UIImage imageNamed:@"city_item_location@2x"] forState:UIControlStateNormal];
            
            //天气
            UILabel *dateLabel = [MyUtiles createLabelWithFrame:CGRectMake((VIEW_WEIGHT-110)/2, 22, 110, 20) font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentCenter color:[UIColor blackColor] text:[NSString stringWithFormat:@"%@",weather]];
            
            //温度
            UILabel *temperatureLabel = [MyUtiles createLabelWithFrame:CGRectMake(VIEW_WEIGHT-90, 32, 70, 20) font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter color:[UIColor blackColor] text:[NSString stringWithFormat:@"%@",temperature]];
            
            //风力风向
            UILabel *windLabel = [MyUtiles createLabelWithFrame:CGRectMake(VIEW_WEIGHT-90, 12, 70, 20) font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter color:[UIColor blackColor] text:[NSString stringWithFormat:@"%@",wind]];
            
            [navView addSubview:windLabel];
            [navView addSubview:temperatureLabel];
            [navView addSubview:cityBtn];
            [navView addSubview:dateLabel];
        });
    }];
    [dataTask resume];
}

// 定位服务状态改变时调用/
 -(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
     switch (status) {
         case kCLAuthorizationStatusNotDetermined:{
             if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                 [self.locationManager requestAlwaysAuthorization];
             }
             NSLog(@"用户还未决定授权");
             break;
         }
         case kCLAuthorizationStatusRestricted:{
             NSLog(@"访问受限");
             break;
         }
         case kCLAuthorizationStatusDenied:{
             // 类方法，判断是否开启定位服务
             if ([CLLocationManager locationServicesEnabled]) {
                 NSLog(@"定位服务开启，被拒绝");
             } else {
                 NSLog(@"定位服务关闭，不可用");
             }
             break;
         }
         case kCLAuthorizationStatusAuthorizedAlways:{
             NSLog(@"获得前后台授权");
             break;
         }
         case kCLAuthorizationStatusAuthorizedWhenInUse:{
             NSLog(@"获得前台授权");
             break;
         }
         default:
             break;
     }
 }

-(void)location{

    NSLog(@"定位未实现");
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    [cityPickerVC setDelegate:self];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
    
}

#pragma mark - GYZCityPickerDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    [cityBtn setTitle:city.cityName forState:UIControlStateNormal];
    NSLog(@"city.cityName is %@",city.cityName);
    currentCity = city.cityName;
    [self getWeatherData];
    [chooseCityController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController
{
    [chooseCityController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma end Delegate

- (void)timerFireMethod:(NSTimer*)theTimer { //弹出框

    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}


@end
