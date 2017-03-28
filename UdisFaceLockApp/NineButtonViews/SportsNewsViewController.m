//
//  SportsNewsViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/23.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "SportsNewsViewController.h"
#import "LLSegmentedControl.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "SportsNewsDetailViewController.h"
#import "JiFenBangDetailViewController.h"
#import "SprottsTableViewCell.h"
#import "SoportsModel.h"
#import "JiFenTableViewCell.h"
#import "JiFenModel.h"
#import "SheShouBangTableViewCell.h"
#import "SheShouBangModel.h"
#import "MyUtiles.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kSports @"https://op.juhe.cn/onebox/football/league?key=f835ca8eda6a7aaa56587c95f292ab2e&league=%@"

@interface SportsNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UISegmentedControl *segmentedControl1; //足球、篮球
@property(nonatomic,strong)LLSegmentedControl *segmentedControl;  // 英超、西甲、中超等
@property(nonatomic,strong)UISegmentedControl *segmentedControl2; //赛程、积分榜、射手榜
@property(nonatomic,strong)NSArray *dataArrayList;
@property(nonatomic,copy)UIView *footBallView;     //足球界面
@property(nonatomic,copy)UIView *basketBallView;   //篮球界面
@property(nonatomic,copy)UIView *saiChengView;     //赛程界面
@property(nonatomic,copy)UIView *jiFenBangView;    //积分榜界面
@property(nonatomic,copy)UIView *sheShouBangView;  //射手榜界面

@end

@implementation SportsNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:51/255.f green:61/255.f blue:70/255.f alpha:1.0];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.extendedLayoutIncludesOpaqueBars = YES;// 延伸导航栏至（0.0)
    _footBallView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    _basketBallView = [[UIView alloc]initWithFrame:CGRectMake(0-kScreenWidth, 64, kScreenWidth, kScreenHeight)];
    _saiChengView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    _jiFenBangView = [[UIView alloc]initWithFrame:CGRectMake(0-kScreenWidth, 64, kScreenWidth, kScreenHeight)];
    _sheShouBangView = [[UIView alloc]initWithFrame:CGRectMake(0+kScreenWidth, 64, kScreenWidth, kScreenHeight)];
    
    _dataArray = [NSMutableArray array];
    _dataArray1 = [NSMutableArray array];
    _dataArray2 = [NSMutableArray array];
    
    [self.view addSubview:_footBallView];
    [self.view addSubview:_basketBallView];
    
    [_footBallView addSubview:_saiChengView];
    [_footBallView addSubview:_jiFenBangView];
    [_footBallView addSubview:_sheShouBangView];
    
    [self creatTextView];
    [self creatSegmentcontrol1];
    [self creatSegmentcontrol2];
    
    [self indexDidChangeForSegmentedControl1:_segmentedControl1]; //进入体育默认足球页面
    [self indexDidChangeForSegmentedControl2:_segmentedControl2];
    [self getData:0];  //默认获取英超数据
}

//赛程、积分榜、射手榜
-(void)creatSegmentcontrol2{
    
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"赛程",@"积分榜",@"射手榜",nil];
    _segmentedControl2 = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl2.frame = CGRectMake((kScreenWidth-180)/2, 35, 180, 25);
    _segmentedControl2.selectedSegmentIndex = 0;
    _segmentedControl2.backgroundColor = [UIColor colorWithRed:64/255.f green:76/255.f blue:86/255.f alpha:1.0];
    _segmentedControl2.tintColor = [UIColor grayColor];
    [_segmentedControl2 addTarget:self  action:@selector(indexDidChangeForSegmentedControl2:)
                 forControlEvents:UIControlEventValueChanged];
    [_footBallView addSubview:_segmentedControl2];
}

//足球、篮球
-(void)creatSegmentcontrol1{

    NSArray *segmentedArray = [NSArray arrayWithObjects:@"足球",@"篮球",nil];
    _segmentedControl1 = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl1.frame = CGRectMake(0, 0, 100, 25);
    _segmentedControl1.selectedSegmentIndex = 0;
    _segmentedControl1.tintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [_segmentedControl1 addTarget:self  action:@selector(indexDidChangeForSegmentedControl1:)
               forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:_segmentedControl1];
}

//足球、篮球分段控制
-(void)indexDidChangeForSegmentedControl1:(UISegmentedControl *)segement{

    int index = (int)_segmentedControl1.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self _footBallView];
            break;
        case 1:
            [self _basketBallView];
            break;
        default:
            break;
    }
}

//赛程、积分榜、射手榜分段控制
-(void)indexDidChangeForSegmentedControl2:(UISegmentedControl *)segement{
    
    int index = (int)_segmentedControl2.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self _saiChengView];
            break;
        case 1:
            [self _jiFenBangView];
            break;
        case 2:
            [self _sheShouBangView];
            break;
        default:
            break;
    }
}

//显示赛程界面
-(void)_saiChengView{

    _saiChengView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
    _jiFenBangView.frame = CGRectMake(0-kScreenWidth, 64, kScreenWidth, kScreenHeight);
    _sheShouBangView.frame = CGRectMake(0+kScreenWidth, 64, kScreenWidth, kScreenHeight);
    _saiChengView.hidden = NO;
    _jiFenBangView.hidden = YES;
    _sheShouBangView.hidden = YES;
    
    [_saiChengView addSubview:_saiChengTb];
}

//显示积分榜界面
-(void)_jiFenBangView{
    
    _saiChengView.frame = CGRectMake(0-kScreenWidth, 64, kScreenWidth, kScreenHeight);
    _jiFenBangView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
    _sheShouBangView.frame = CGRectMake(0+kScreenWidth, 64, kScreenWidth, kScreenHeight);
    _saiChengView.hidden = YES;
    _jiFenBangView.hidden = NO;
    _sheShouBangView.hidden = YES;
    
    [_jiFenBangView addSubview:_jiFenBangTb];
}

//显示射手榜界面
-(void)_sheShouBangView{
    
    _saiChengView.frame = CGRectMake(0-kScreenWidth, 64, kScreenWidth, kScreenHeight);
    _jiFenBangView.frame = CGRectMake(0+kScreenWidth, 64, kScreenWidth, kScreenHeight);
    _sheShouBangView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
    _saiChengView.hidden = YES;
    _jiFenBangView.hidden = YES;
    _sheShouBangView.hidden = NO;
    
    [_sheShouBangView addSubview:_sheShouBangTb];
}

-(void)_footBallView{

    [_segmentedControl removeFromSuperview];
    _footBallView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
    _basketBallView.frame = CGRectMake(0-kScreenWidth, 64, kScreenWidth, kScreenHeight);
    _footBallView.hidden = NO;
    _basketBallView.hidden = YES;
    [_saiChengView addSubview:_saiChengTb];     //加载赛程tableView
    _dataArrayList = @[@"英超", @"西甲", @"中超", @"法甲",@"意甲",@"德甲"];
    [self creatSegementControlSelect:_segmentedControl];
    
}

-(void)_basketBallView{

    [_segmentedControl removeFromSuperview];
    _footBallView.frame = CGRectMake(0-kScreenWidth, 64, kScreenWidth, kScreenHeight);
    _basketBallView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
    _footBallView.hidden = YES;
    _basketBallView.hidden = NO;
    _dataArrayList = @[@"赛程", @"得分榜", @"积分榜", @"视频集锦",@"关注球队",@"技术统计"];
    [self creatSegementControlSelect:_segmentedControl];
}

// 英超、西甲、中超等分段控制
-(void)creatSegementControlSelect:(LLSegmentedControl *)segement{
    
    self.segmentedControl = [[LLSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30) titleArray:_dataArrayList];
    _segmentedControl.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    _segmentedControl.segmentedControlLineStyle = LLSegmentedControlStyleUnderline;
    _segmentedControl.lineWidthEqualToTextWidth = YES;
    _segmentedControl.textColor = [UIColor darkTextColor];
    _segmentedControl.selectedTextColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    _segmentedControl.font = [UIFont systemFontOfSize:13];
    _segmentedControl.selectedFont = [UIFont boldSystemFontOfSize:15];
    _segmentedControl.lineColor = [UIColor colorWithRed:51/255.f green:61/255.f blue:70/255.f alpha:1.0];
    _segmentedControl.lineHeight = 2.f;
    // segmentedControlTitleSpacingStyle 设置为 LLSegmentedControlTitleSpacingStyleSpacingFixed
    // 则不需要设置 titleWidth 属性
    _segmentedControl.titleSpacing = 30;
    _segmentedControl.defaultSelectedIndex = 0;
    // 分割线设置
    _segmentedControl.showSplitLine = YES;
    _segmentedControl.splitLineSize = CGSizeMake(1, 25);
    
    [_footBallView addSubview:_segmentedControl];
    
    [_segmentedControl segmentedControlSelectedWithBlock:^(LLSegmentedControl *segmentedControl, NSInteger selectedIndex) {
        NSLog(@"selectedIndex : %zd", selectedIndex);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_dataArray removeAllObjects];
        [_dataArray1 removeAllObjects];
        [_dataArray2 removeAllObjects];
        [self getData:(NSInteger)selectedIndex];
    }];
}

-(void)getData:(NSInteger)selectedIndex{

    NSString *url = [NSString stringWithFormat:kSports,_dataArrayList[selectedIndex]];
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = [responseObject objectForKey:@"result"];
        NSDictionary *views = [result objectForKey:@"views"];
        NSDictionary *tabs = [result objectForKey:@"tabs"];
        _saicheng1Arr = [views objectForKey:@"saicheng1"]; //第21轮赛程
        _saicheng2Arr = [views objectForKey:@"saicheng2"]; //第22轮赛程
        _sheshoubangArr = [views objectForKey:@"sheshoubang"]; //射手榜
        _jifenbangArr = [views objectForKey:@"jifenbang"];     //积分榜
        NSString *saicheng1 = [tabs objectForKey:@"saicheng1"]; //第21轮赛程
        NSString *saicheng2 = [tabs objectForKey:@"saicheng2"]; //第22轮赛程
        _headerStrArr = @[saicheng1,saicheng2];
        _arr = [NSMutableArray arrayWithObjects:_saicheng1Arr,_saicheng2Arr, nil];
        NSArray *models = [SoportsModel arrayOfModelsFromDictionaries:_arr];        
        [_dataArray addObjectsFromArray:models];
        NSLog(@"_dataArray is %@",_dataArray);
        [_saiChengTb reloadData];       //赛程加载数据
        NSArray *models1 = [JiFenModel arrayOfModelsFromDictionaries:_jifenbangArr];
        [_dataArray1 addObjectsFromArray:models1];
        [_jiFenBangTb reloadData];      //积分榜加载数据
        NSArray *model2 =[SheShouBangModel arrayOfModelsFromDictionaries:_sheshoubangArr];
        [_dataArray2 addObjectsFromArray:model2];
        [_sheShouBangTb reloadData];    //射手榜加载数据
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@" error is%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)creatTextView{

    _saiChengTb = [MyUtiles createTableView:CGRectMake(0, 5, kScreenWidth, kScreenHeight-30-30-30) tableViewStyle:UITableViewStylePlain backgroundColor:[UIColor colorWithRed:51/255.f green:61/255.f blue:70/255.f alpha:1.0] separatorColor:[UIColor colorWithRed:64/255.f green:76/255.f blue:86/255.f alpha:1.0] separatorStyle:UITableViewCellSeparatorStyleSingleLine showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO];
    _saiChengTb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    _saiChengTb.delegate = self;
    _saiChengTb.dataSource =self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_saiChengTb registerNib:[UINib nibWithNibName:@"SprottsTableViewCell" bundle:nil] forCellReuseIdentifier:@"SprottsTableViewCell"];
    
    _jiFenBangTb = [MyUtiles createTableView:CGRectMake(0, 5, kScreenWidth, kScreenHeight-30-30-30) tableViewStyle:UITableViewStylePlain backgroundColor:[UIColor colorWithRed:51/255.f green:61/255.f blue:70/255.f alpha:1.0] separatorColor:[UIColor colorWithRed:64/255.f green:76/255.f blue:86/255.f alpha:1.0] separatorStyle:UITableViewCellSeparatorStyleSingleLine showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO];
    _jiFenBangTb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    _jiFenBangTb.delegate = self;
    _jiFenBangTb.dataSource =self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_jiFenBangTb registerNib:[UINib nibWithNibName:@"JiFenTableViewCell" bundle:nil] forCellReuseIdentifier:@"JiFenTableViewCell"];
    
    _sheShouBangTb = [MyUtiles createTableView:CGRectMake(0, 5, kScreenWidth, kScreenHeight-30-30-30) tableViewStyle:UITableViewStylePlain backgroundColor:[UIColor colorWithRed:51/255.f green:61/255.f blue:70/255.f alpha:1.0] separatorColor:[UIColor colorWithRed:64/255.f green:76/255.f blue:86/255.f alpha:1.0] separatorStyle:UITableViewCellSeparatorStyleSingleLine showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO];
    _sheShouBangTb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    _sheShouBangTb.delegate = self;
    _sheShouBangTb.dataSource =self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_sheShouBangTb registerNib:[UINib nibWithNibName:@"SheShouBangTableViewCell" bundle:nil] forCellReuseIdentifier:@"SheShouBangTableViewCell"];
    
}

#pragma mark - TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    if (tableView == _saiChengTb) {
        return _arr.count;
    }else
        return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _saiChengTb) {
        NSArray * arr = _arr[section];
        return arr.count;
    }else if(tableView == _jiFenBangTb){
        return _jifenbangArr.count;
    }else{
        return _sheshoubangArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _saiChengTb) {
        SprottsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SprottsTableViewCell" forIndexPath:indexPath];
        cell.model = _dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:51/255.f green:61/255.f blue:70/255.f alpha:1.0];
        return cell;
    }else if(tableView == _jiFenBangTb){
        JiFenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JiFenTableViewCell" forIndexPath:indexPath];
        cell.model = _dataArray1[indexPath.row];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            cell.backgroundColor = [UIColor colorWithRed:50/255.f green:205/255.f blue:50/255.f alpha:1.0];
        }else{
        cell.backgroundColor = [UIColor colorWithRed:51/255.f green:61/255.f blue:70/255.f alpha:1.0];
        }
        return cell;
    }else{
        SheShouBangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SheShouBangTableViewCell" forIndexPath:indexPath];
        cell.model = _dataArray2[indexPath.row];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:51/255.f green:61/255.f blue:70/255.f alpha:1.0];
        return cell;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //每一段的头部
    if (tableView == _saiChengTb) {
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,30)];
        view1.backgroundColor = [UIColor colorWithRed:64/255.f green:76/255.f blue:86/255.f alpha:1.0];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 30)];
        label.text = [NSString stringWithFormat:@"%@",_headerStrArr[section]];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentRight;
        [view1 addSubview:label];
        return view1;
    }else if (tableView == _jiFenBangTb){
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,30)];
        view1.backgroundColor = [UIColor colorWithRed:64/255.f green:76/255.f blue:86/255.f alpha:1.0];
        UILabel * teamLabel = [MyUtiles createLabelWithFrame:CGRectMake(50, 5, 75, 20) font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentLeft color:[UIColor whiteColor] text:@"球队"];
        UILabel * totleLabel = [MyUtiles createLabelWithFrame:CGRectMake(135, 5, 25, 20) font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentLeft color:[UIColor whiteColor] text:@"场次"];
        UILabel * victoryLabel = [MyUtiles createLabelWithFrame:CGRectMake(185, 5, 30, 20) font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentLeft color:[UIColor whiteColor] text:@"胜"];
        UILabel * equalLabel = [MyUtiles createLabelWithFrame:CGRectMake(220, 5, 30, 20) font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentLeft color:[UIColor whiteColor] text:@"平"];
        UILabel * loseLabel = [MyUtiles createLabelWithFrame:CGRectMake(255, 5, 30, 20) font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft color:[UIColor whiteColor] text:@"负"];
        UILabel * scoreLabel = [MyUtiles createLabelWithFrame:CGRectMake(285, 5, 30, 20) font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentLeft color:[UIColor whiteColor] text:@"积分"];
        [view1 addSubview:teamLabel];
        [view1 addSubview:totleLabel];
        [view1 addSubview:victoryLabel];
        [view1 addSubview:equalLabel];
        [view1 addSubview:loseLabel];
        [view1 addSubview:scoreLabel];
        return view1;
    }else{
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,30)];
        view1.backgroundColor = [UIColor colorWithRed:64/255.f green:76/255.f blue:86/255.f alpha:1.0];
        UILabel * palyerLabel = [MyUtiles createLabelWithFrame:CGRectMake(50, 5, 80, 20) font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentCenter color:[UIColor whiteColor] text:@"球员"];
        UILabel * goalLabel = [MyUtiles createLabelWithFrame:CGRectMake(135, 5, 40, 20) font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentCenter color:[UIColor whiteColor] text:@"进球"];
        UILabel * assistLabel = [MyUtiles createLabelWithFrame:CGRectMake(185, 5, 40, 20) font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentCenter color:[UIColor whiteColor] text:@"助攻"];
        UILabel * teamLabel = [MyUtiles createLabelWithFrame:CGRectMake(240, 5, 70, 20) font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentCenter color:[UIColor whiteColor] text:@"球队"];
        [view1 addSubview:palyerLabel];
        [view1 addSubview:goalLabel];
        [view1 addSubview:assistLabel];
        [view1 addSubview:teamLabel];
        return view1;
    }
}

//段头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"点击的第%ld行", (long)indexPath.row);
    self.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    if (tableView == _saiChengTb) {
        SportsNewsDetailViewController *detialsVc = [[SportsNewsDetailViewController alloc]init];
        SoportsModel *model = _dataArray[indexPath.row];
        [detialsVc setValue:model.c52Link forKey:@"c52Link"];
        [self.navigationController pushViewController:detialsVc animated:YES];
    }else{
        JiFenBangDetailViewController *jiFenBangDetailVc = [[JiFenBangDetailViewController alloc]init];
        JiFenModel *model1 = _dataArray1[indexPath.row];
        [jiFenBangDetailVc setValue:model1.c2L forKey:@"c2L"];
        [self.navigationController pushViewController:jiFenBangDetailVc animated:YES];
    }
    self.hidesBottomBarWhenPushed = YES;
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
