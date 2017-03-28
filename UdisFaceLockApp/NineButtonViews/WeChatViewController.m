//
//  WeChatViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/21.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "WeChatViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPSessionManager.h"
#import "MJRefresh.h"
#import "WechatDetailViewController.h"
#import "WeChatModel.h"
#import "WeChatTableViewCell.h"

#define kWeChat @"https://v.juhe.cn/weixin/query?pno=&ps=&dtype=&key=c7e2c15c0559e006123240aa81ca256e"
@interface WeChatViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WeChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"微信精选";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.extendedLayoutIncludesOpaqueBars = YES;// 延伸导航栏至（0.0)
    
    [self creatTextView];
    [self loadData];

}

-(void)creatTextView{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _dataArray = [[NSMutableArray alloc]init];
    _tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    //[_tb.mj_header beginRefreshing];
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.backgroundColor = [UIColor whiteColor];
    _tb.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //_tb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    [_tb registerNib:[UINib nibWithNibName:@"WeChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"WeChatTableViewCell"];
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
        [self loadData];
    }];
    
    _tb.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [_dataArray removeAllObjects];
        [self loadData];
    }];
}

-(void)loadData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self creatTextView];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:kWeChat parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取微信精选成功");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //NSLog(@"新闻头条 task is %@",task);
        // NSLog(@"新闻头条 responseObject is %@",responseObject);
        NSDictionary *newsDic = [responseObject objectForKey:@"result"];
        // NSLog(@"newsArr is %@", newsArr);
        NSArray *dataArr = [newsDic objectForKey:@"list"];
        NSArray *models = [WeChatModel arrayOfModelsFromDictionaries:dataArr];
        [_dataArray addObjectsFromArray:models];
        [_tb reloadData];
        [_tb.mj_header endRefreshing];
        [_tb.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取微信精选失败");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"微信精选 error is%@",error);
        [_tb.mj_header endRefreshing];
        [_tb.mj_footer endRefreshing];
        [self showAlert:@"微信精选获取失败，请返回重试!"];
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
    
    WeChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeChatTableViewCell" forIndexPath:indexPath];
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
    WechatDetailViewController *detialsVc = [[WechatDetailViewController alloc]init];
    WeChatModel *model = _dataArray[indexPath.row];
    [detialsVc setValue:model.url forKey:@"url"];
    [self.navigationController pushViewController:detialsVc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
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
