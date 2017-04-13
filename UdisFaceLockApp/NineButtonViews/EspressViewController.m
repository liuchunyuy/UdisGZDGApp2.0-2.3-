//
//  EspressViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/4/7.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "EspressViewController.h"
#import "MyUtiles.h"
#import "MBProgressHUD.h"
#import "AFHTTPSessionManager.h"
#import "ExpressTimeTableViewCell.h"
#import "ExpressTimeModel.h"

#import "MBProgressHUD.h"
#import "MJRefresh.h"

#define VIEW_HEIGTH self.view.frame.size.height
#define VIEW_WEIGHT self.view.frame.size.width
#define kExpress @"https://www.wenlong.org/kuaidi/"
@interface EspressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITextField *inPutTextfield;
//@property(nonatomic,strong)NSMutableArray *expressMessageArr;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end


@implementation EspressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"快递物流查询";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    //_expressMessageArr = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self createTableView];
    [self createView];
    
}

-(void)createView{

    _inPutTextfield = [MyUtiles createTextField:CGRectMake(20, 20, 3*((VIEW_WEIGHT-40-10)/4), 30) placeholder:@"输入快递单号" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor whiteColor] keyboardType:UIKeyboardTypeNumbersAndPunctuation viewMode:UITextFieldViewModeAlways secureTextEntry:NO];
    //默认是上次输入的快递单号
    _inPutTextfield.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"inputExpressNum"];
    _inPutTextfield.textAlignment = NSTextAlignmentLeft;
    [_inPutTextfield endEditing:YES];
    _inPutTextfield.layer.masksToBounds = YES;
    _inPutTextfield.layer.cornerRadius = 5;
    [self.view addSubview:_inPutTextfield];
    
    UIButton *searchBtn = [MyUtiles createBtnWithFrame:CGRectMake(20+_inPutTextfield.frame.size.width+10, 20, (VIEW_WEIGHT-40-10)/4, 30) title:@"查询" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(search)];
    searchBtn.backgroundColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 5;
    [searchBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [searchBtn.layer setBorderWidth:1];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
}

-(void)createTableView{

    
    _tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, VIEW_WEIGHT, VIEW_HEIGTH-64-60)];

    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    _tb.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //_tb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    [_tb registerNib:[UINib nibWithNibName:@"ExpressTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExpressTimeTableViewCell"];
    _tb.showsHorizontalScrollIndicator = NO;
    _tb.showsVerticalScrollIndicator = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tb.separatorStyle = UITableViewCellSeparatorStyleNone; // 取消cell的分割线
    [self.view addSubview:_tb];
    [self addHeaderFooter];
}

-(void)addHeaderFooter{
    
    _tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block        
        [self search];
    }];
    
}

-(void)search{

    [self.view endEditing:YES];
    [[NSUserDefaults standardUserDefaults] setObject:_inPutTextfield.text forKey:@"inputExpressNum"];
    //47941440031
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [_dataArray removeAllObjects];
    NSLog(@"查询快递物流");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //参数
    NSDictionary *parma = @{@"c":_inPutTextfield.text};
    
    [manager POST:kExpress parameters:parma progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject is %@",responseObject);
        NSArray * expressMessageArr = [responseObject objectForKey:@"data"];
        NSLog(@"_expressMessageArr is %@",expressMessageArr);
        NSLog(@"message is %@",[responseObject objectForKey:@"message"]);
        if ([[responseObject objectForKey:@"message"] isEqualToString:@"ok"]) {
            NSArray *models = [ExpressTimeModel arrayOfModelsFromDictionaries:expressMessageArr];
            [_dataArray addObjectsFromArray:models];
            [_tb reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [_tb.mj_header endRefreshing];
            return ;
        }
        [_tb reloadData];
        [self showAlert:[responseObject objectForKey:@"message"]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_tb.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showAlert:@"物流信息查询失败，请稍后重试"];
        [_tb.mj_header endRefreshing];
        
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
    
    ExpressTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpressTimeTableViewCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  //右箭头
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    if (indexPath.row == 0) {
        cell.statueLabel.textColor = [UIColor orangeColor];
    }
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
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
