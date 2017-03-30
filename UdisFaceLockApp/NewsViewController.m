//
//  NewsViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/20.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsModel.h"
#import "NewsTableViewCell.h"
#import "NewsDetailsViewController.h"
#import "AFHTTPSessionManager.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

#import "LLSegmentedControl.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kNews @"https://v.juhe.cn/toutiao/index?type=%@&key=efbe1e1d1289b682bc343e1677b3660b"
@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)LLSegmentedControl *segmentedControl;  // 头条、娱乐、体育等分类
@property(nonatomic,strong)NSArray *dataArrayList;
@property(nonatomic,strong)NSArray *dataArrayListType;
@property(nonatomic)NSInteger selectIndex;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"新闻头条";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.extendedLayoutIncludesOpaqueBars = YES;// 延伸导航栏至（0.0)
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self createSegmentControl];
    [self creatTextView];
    [self loadData:0];

}

-(void)createSegmentControl{

    //top(头条，默认),shehui(社会),guonei(国内),guoji(国际),yule(娱乐),tiyu(体育)junshi(军事),keji(科技),caijing(财经),shishang(时尚)
    _dataArrayList = @[@"头条", @"社会", @"国内", @"国际",@"娱乐",@"体育",@"军事",@"科技",@"财经",@"时尚"];
    _dataArrayListType = @[@"top", @"shehui", @"guonei", @"guoji",@"yule",@"tiyu",@"junshi",@"keji",@"caijing",@"shishang"];
    self.segmentedControl = [[LLSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 30) titleArray:_dataArrayList];
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
    
    [self.view addSubview:_segmentedControl];
    
    [_segmentedControl segmentedControlSelectedWithBlock:^(LLSegmentedControl *segmentedControl, NSInteger selectedIndex) {
        NSLog(@"selectedIndex : %zd", selectedIndex);
        _selectIndex = selectedIndex;
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_dataArray removeAllObjects];
        
        [self loadData:_selectIndex];
    }];
}

-(void)creatTextView{

    _dataArray = [[NSMutableArray alloc]init];
    _tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+30, self.view.bounds.size.width, self.view.bounds.size.height-64-30)];
    //[_tb.mj_header beginRefreshing];
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.backgroundColor = [UIColor whiteColor];
    _tb.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //_tb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    [_tb registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsTableViewCell"];
    _tb.showsHorizontalScrollIndicator = NO;
    _tb.showsVerticalScrollIndicator = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //_tb.separatorStyle = UITableViewCellSeparatorStyleNone;  取消cell的分割线
    [self.view addSubview:_tb];
    
    [self addHeaderFooter];
    
}

-(void)addHeaderFooter{

    _tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_dataArray removeAllObjects];
        [self loadData:_selectIndex];
    }];
    
//    _tb.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [_dataArray removeAllObjects];
//        [self loadData:_selectIndex];
//    }];

}

-(void)loadData:(NSInteger )index{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[self creatTextView];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:kNews,_dataArrayListType[index]];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取新闻头条成功");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *newsDic = [responseObject objectForKey:@"result"];
        NSArray *dataArr = [newsDic objectForKey:@"data"];
        
        NSArray *models = [NewsModel arrayOfModelsFromDictionaries:dataArr];
        [_dataArray addObjectsFromArray:models];
        [_tb reloadData];
        [_tb.mj_header endRefreshing];
        [_tb.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取新闻头条失败");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"新闻头条 error is%@",error);
        [_tb.mj_header endRefreshing];
        [_tb.mj_footer endRefreshing];
        [self showAlert:@"新闻获取失败，请返回重试!"];
    }];
}

#pragma mark - TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"_dataArray.count = %lu",(unsigned long)_dataArray.count);
    return _dataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  //右箭头
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击的第%ld行", (long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    NewsDetailsViewController *detialsVc = [[NewsDetailsViewController alloc]init];
    NewsModel *model = _dataArray[indexPath.row];
    //[detialsVc setValue:model.uniquekey forKey:@"uniquekey"];
    [detialsVc setValue:model.url forKey:@"url"];
    [self.navigationController pushViewController:detialsVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

- (void)timerFireMethod:(NSTimer*)theTimer { //弹出框
    
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
