//
//  NewMessageController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/8/9.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "NewMessageController.h"
#import "MyUtiles.h"
#import "NewMessageTableViewCell.h"
#import "NewMessageModel.h"
#import "RegisteredController.h"
#import "NewMessageDetailsViewController.h"
#import "MBProgressHUD.h"
// 字符串为 nil null <null>的时候 替代方法
#define HH_IsEmptyString(object)\
(  (object == nil || \
[object isKindOfClass:[NSNull class]] ||\
[object isEqualToString:@"(null)"] || \
[object isEqualToString:@"null"] || \
[object isEqualToString:@"<null>"] )\
== 1 ? @"无":object\
)

#define HH_IsEmptyString1(object)\
(  (object == nil || \
[object isKindOfClass:[NSNull class]] ||\
[object isEqualToString:@"(null)"] || \
[object isEqualToString:@"null"] || \
[object isEqualToString:@"<null>"] )\
== 1 ? @"moren1":object\
)

#define HH_IsEmptyString2(object)\
(  (object == nil || \
[object isKindOfClass:[NSNull class]] ||\
[object isEqualToString:@"(null)"] || \
[object isEqualToString:@"null"] || \
[object isEqualToString:@"<null>"] ||\
[object isEqualToString:@"\n"]||\
[object isEqualToString:@""])\
== 1 ? @"无标题":object\
)

@interface NewMessageController ()<UITableViewDelegate,UITableViewDataSource>{

    UIImageView *_backGroundImg;
   
}
@property(nonatomic,copy)NSMutableArray *titleMessageArr;
@property(nonatomic,copy)NSMutableArray *messageArr;
@property(nonatomic,copy)UIAlertView *alert;

@end

@implementation NewMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    addBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addBtn;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self creatTextView];

    // Do any additional setup after loading the view.
}

-(void)creatTextView{
    
    _dataArray = [[NSMutableArray alloc]init];
    _messageArr = [NSMutableArray array];
    _titleMessageArr = [NSMutableArray array];
    _tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-113)];
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.backgroundColor = [UIColor whiteColor];
    _tb.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    [_tb registerNib:[UINib nibWithNibName:@"NewMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewMessageTableViewCell"];
    _tb.showsHorizontalScrollIndicator = NO;
    _tb.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //_tb.separatorStyle = UITableViewCellSeparatorStyleNone;  取消cell的分割线
    [self.view addSubview:_tb];

    NSLog(@"_messagesArr is %@", _messagesArr);
    
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
        for (dic1 in _messagesArr) {
            NewMessageModel *model = [[NewMessageModel alloc]init];

            NSString *titleStr = [dic1 objectForKey:@"message"];
            NSString *str = [dic1[@"messageTitle"] stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *str1 = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            model.message = HH_IsEmptyString2(str3);
            model.messageImg = HH_IsEmptyString1(dic1[@"messageImg"]);
            [_titleMessageArr addObject:str];
            [_messageArr addObject:titleStr];
            
            if ((dic1[@"datetime"] == nil ||
                 [dic1[@"datetime"] isKindOfClass:[NSNull class]] ||
                 [dic1[@"datetime"] isEqualToString:@"(null)"] ||
                 [dic1[@"datetime"] isEqualToString:@"null"] ||
                 [dic1[@"datetime"] isEqualToString:@"<null>"] )) {
                NSDate *date=[NSDate date];//获取当前时间
                NSDateFormatter *format1=[[NSDateFormatter alloc]init];
                [format1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *str1=[format1 stringFromDate:date];
               // NSLog(@"str1  is  ----%@", str1);
                model.datetime = str1;
            }else{
               // model.datetime = dic1[@"datetime"];
                model.datetime = [NSString stringWithFormat:@"截止日期: %@",dic1[@"datetime"]];
            }
            NSLog(@"message is %@", model.message);
            NSLog(@"datetime is %@", model.datetime);
            NSLog(@"messageImg is %@", model.messageImg);
        
            [_dataArray addObject:model];
            
            NSLog(@"_dataArray is %@", _dataArray);
        }
        [_tb reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    
    NewMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMessageTableViewCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  //右箭头
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _alert = [[UIAlertView alloc]initWithTitle:_titleMessageArr[indexPath.row] message:_messageArr[indexPath.row] delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [_alert show];
    UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizerTap setNumberOfTapsRequired:1];
    recognizerTap.cancelsTouchesInView = NO;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:recognizerTap];
}

//点空白alertview消失
- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![_alert pointInside:[_alert convertPoint:location fromView:_alert.window] withEvent:nil]){
            [_alert.window removeGestureRecognizer:sender];
            [_alert dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}


-(void)refresh{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_dataArray removeAllObjects];
    [self creatTextView];
}


-(void)backAction:(UIButton *)btn{

    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
