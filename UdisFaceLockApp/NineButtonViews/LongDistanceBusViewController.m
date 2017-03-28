//
//  LongDistanceBusViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/22.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "LongDistanceBusViewController.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "LongDistanceBusModel.h"
#import "LongDistanceBusTableViewCell.h"
#import "MyUtiles.h"

#define kLongDistanceBus @"https://op.juhe.cn/onebox/bus/query_ab?key=f559fdcad480468f0564507b5a6a7f3f&from=%@&to=%@"
#define VIEW_HEIGTH self.view.frame.size.height
#define VIEW_WEIGHT self.view.frame.size.width
@interface LongDistanceBusViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>

@end

@implementation LongDistanceBusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"汽车时刻和价格查询";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.extendedLayoutIncludesOpaqueBars = YES;// 延伸导航栏至（0.0)
    
    //添加self.view的点击事件（点击屏幕空白取消键盘）
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    UILabel *shiFaLabel = [MyUtiles createLabelWithFrame:CGRectMake((VIEW_WEIGHT-280)/3, 65, 40, 40) font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter color:[UIColor blackColor] text:@"始发:"];
    [self.view addSubview:shiFaLabel];
    
    _startStationTextField = [MyUtiles createTextField:CGRectMake((VIEW_WEIGHT-280)/3 + 40, 70, 100, 30) placeholder:@"始发城市" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor whiteColor] keyboardType:UIKeyboardTypeDefault viewMode:UITextFieldViewModeAlways secureTextEntry:NO];
    [_startStationTextField endEditing:YES];
    _startStationTextField.textAlignment = NSTextAlignmentCenter;
    _startStationTextField.layer.masksToBounds = YES;
    _startStationTextField.layer.cornerRadius = 5;
    _startStationTextField.returnKeyType = UIReturnKeySearch;
    _startStationTextField.delegate = self;
    [self.view addSubview:_startStationTextField];
    
    UILabel *zhongDaoLabel = [MyUtiles createLabelWithFrame:CGRectMake(140+2*(VIEW_WEIGHT-280)/3, 65, 40, 40) font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter color:[UIColor blackColor] text:@"终到:"];
    [self.view addSubview:zhongDaoLabel];
    
    _arriveStationTextField = [MyUtiles createTextField:CGRectMake(140+2*(VIEW_WEIGHT-280)/3 +40, 70, 100, 30) placeholder:@"终到城市" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor whiteColor] keyboardType:UIKeyboardTypeDefault viewMode:UITextFieldViewModeAlways secureTextEntry:NO];
    _arriveStationTextField.textAlignment = NSTextAlignmentCenter;
    [_arriveStationTextField endEditing:YES];
    _arriveStationTextField.layer.masksToBounds = YES;
    _arriveStationTextField.layer.cornerRadius = 5;
    _arriveStationTextField.returnKeyType = UIReturnKeySearch;
    _arriveStationTextField.delegate = self;
    [self.view addSubview:_arriveStationTextField];
    
    UIButton *getBtn = [MyUtiles createBtnWithFrame:CGRectMake((VIEW_WEIGHT-60)/2, 105, 60, 30) title:@"查询" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(loadData)];
    getBtn.backgroundColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    getBtn.layer.masksToBounds = YES;
    getBtn.layer.cornerRadius = 5;
    [getBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [getBtn.layer setBorderWidth:1];
    [getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:getBtn];
    
    UILabel *tipLabel = [MyUtiles createLabelWithFrame:CGRectMake(0, 138, VIEW_WEIGHT, 20) font:[UIFont systemFontOfSize:10] textAlignment:NSTextAlignmentCenter color:[UIColor grayColor] text:@"- 仅供参考,具体发车时间及价格以车站公布为准 -"];
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipLabel];
    
    //[self loadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [_startStationTextField resignFirstResponder];
    [_arriveStationTextField resignFirstResponder];
    [self loadData];
    return YES;
}

-(void)creatTextView{
    
    _dataArray = [[NSMutableArray alloc]init];
    _tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 167, self.view.bounds.size.width, self.view.bounds.size.height-167)];
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.backgroundColor = [UIColor whiteColor];
    _tb.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    [_tb registerNib:[UINib nibWithNibName:@"LongDistanceBusTableViewCell" bundle:nil] forCellReuseIdentifier:@"LongDistanceBusTableViewCell"];
    _tb.showsHorizontalScrollIndicator = NO;
    _tb.showsVerticalScrollIndicator = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //_tb.separatorStyle = UITableViewCellSeparatorStyleNone;  取消cell的分割线
    [self.view addSubview:_tb];
    
}

-(void)loadData{
    
    [_dataArray removeAllObjects];
    [_tb reloadData];
    
    [_startStationTextField endEditing:YES];
    [_arriveStationTextField endEditing:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([_startStationTextField.text isEqualToString:@""] | [_arriveStationTextField.text isEqualToString:@""]) {
        [self showAlert:@"始发站或终点站内容不能为空"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }else if ([_startStationTextField.text isEqualToString:_arriveStationTextField.text]){
        [self showAlert:@"始发站和终点站不能相同，请重新输入"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *url = [NSString stringWithFormat:kLongDistanceBus,_startStationTextField.text,_arriveStationTextField.text];
        NSString *str = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"长途汽车车票查询成功");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"长途汽车车票查询 responseObject is %@",responseObject);
            NSString *codeNum = [[responseObject objectForKey:@"error_code"] stringValue];
            NSString *reason = [responseObject objectForKey:@"reason"];
            NSLog(@"code is %@", codeNum);
            if ([codeNum isEqualToString:@"208205"] ) {
                [self showAlert:reason];
                return ;
            }else if([codeNum isEqualToString:@"208203"]){
                [self showAlert:reason];
                return ;
            }else if([codeNum isEqualToString:@"208204"]){
                [self showAlert:reason];
                return ;
            }else{
                [self creatTextView];
                NSDictionary *newsDic = [responseObject objectForKey:@"result"];
                NSArray *dataArr = [newsDic objectForKey:@"list"];
                NSArray *models = [LongDistanceBusModel arrayOfModelsFromDictionaries:dataArr];
                [_dataArray addObjectsFromArray:models];
                [_tb reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"长途汽车车票查询失败");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"长途汽车车票查询 error is%@",error);
            [self showAlert:@"长途汽车信息查询失败，请返回重试!"];
        }];
    }
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
    
    LongDistanceBusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LongDistanceBusTableViewCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  //右箭头
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return;
    NSLog(@"点击的第%ld行", (long)indexPath.row);
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

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.nameTextField resignFirstResponder];
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
