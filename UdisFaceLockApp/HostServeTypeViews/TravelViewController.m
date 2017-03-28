//
//  TravelViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/5.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "TravelViewController.h"
#import "MyUtiles.h"

@interface TravelViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSArray *nameArr;
@property (nonatomic,strong)NSArray *numArr;

@end

@implementation TravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"旅游";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.extendedLayoutIncludesOpaqueBars = YES;// 延伸导航栏至（0.0
    
    _numArr = [NSArray array];
    _nameArr = [NSArray array];
    _nameArr = @[@"携程网",@"艺龙网",@"同程网",@"芒果网",@"途牛网",@"去哪网"];
    _numArr = @[@"4008206666",@"4009333333",@"4007777777",@"4006640066",@"4007999999",@"10101234"];
    
    [self createView];

}

-(void)createView{
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 29, self.view.bounds.size.width, self.view.bounds.size.height-29) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _nameArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    UIButton *btn = [MyUtiles createBtnWithFrame:CGRectMake(self.view.frame.size.width-50, 15, 20, 20) title:nil normalBgImg:@"phone@2x_2" highlightedBgImg:nil target:self action:@selector(tel:)];
    [btn setTitleColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.tag = indexPath.row + 1000;
    [cell addSubview:btn];
    cell.textLabel.text = _nameArr[indexPath.row];
    cell.detailTextLabel.text = _numArr[indexPath.row];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;  //点击没有效果
    //cell.userInteractionEnabled = NO;  //不能点击cell
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = _nameArr[indexPath.row];
    cell.detailTextLabel.text = _numArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(void)tel:(UIButton *)btn{
    
    NSInteger num = btn.tag - 1000;
    NSLog(@"打电话给:--- %@", _nameArr[num]);
    NSString *telStr = [NSString stringWithFormat:@"%@", _numArr[num]];
    UIWebView *callWebView = [[UIWebView alloc] init];
    NSURL *telURL= [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telStr]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"打电话给: %@", _nameArr[indexPath.row]);
    NSString *telStr = [NSString stringWithFormat:@"%@", _numArr[indexPath.row]];
    UIWebView *callWebView = [[UIWebView alloc] init];
    NSURL *telURL= [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telStr]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebView];
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
