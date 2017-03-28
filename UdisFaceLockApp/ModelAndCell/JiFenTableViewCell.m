//
//  JiFenTableViewCell.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/1/10.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "JiFenTableViewCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation JiFenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(JiFenModel *)model{
    
    if (_model != model) {
        _model = model;
        /*
         @property (nonatomic,copy) NSString *c1;   // 排名
         @property (nonatomic,copy) NSString *c2;   // 球队
         @property (nonatomic,copy) NSString *c3;   // 场次
         @property (nonatomic,copy) NSString *c41;  // 胜
         @property (nonatomic,copy) NSString *c42;  // 平
         @property (nonatomic,copy) NSString *c43;  // 负
         @property (nonatomic,copy) NSString *c6;   // 积分
         @property (nonatomic,copy) NSString *c2L;  // 链接
         */
       // NSLog(@"_model.c1 is ----%@",_model.c1);
        
        _rankLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.c1];
        _teamLabel.text = _model.c2;
        _totleLabel.text = _model.c3;
        _victoryLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.c41] ;
        _equalLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.c42];
        _loseLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.c43];
        _scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.c6];
        
        _rankLabel.textColor = [UIColor whiteColor];
        _teamLabel.textColor = [UIColor whiteColor];
        _totleLabel.textColor = [UIColor whiteColor];
        _victoryLabel.textColor = [UIColor whiteColor];
        _equalLabel.textColor = [UIColor whiteColor];
        _loseLabel.textColor = [UIColor whiteColor];
        
        _rankLabel.frame = CGRectMake(10, 10, 20, 20);
        _teamLabel.frame = CGRectMake(30+(kScreenWidth-220)/6, 10, 80, 20);
        _totleLabel.frame = CGRectMake(2*(kScreenWidth-220)/6+110, 10, 20, 20);
        _victoryLabel.frame = CGRectMake(130+3*(kScreenWidth-220)/6, 10, 20, 20);
        _equalLabel.frame = CGRectMake(150+4*(kScreenWidth-220)/6, 10, 20, 20);
        _loseLabel.frame = CGRectMake(170+5*(kScreenWidth-220)/6, 10, 20, 20);
        _scoreLabel.frame = CGRectMake(190+6*(kScreenWidth-220)/6, 10, 20, 20);
    }
}

@end
