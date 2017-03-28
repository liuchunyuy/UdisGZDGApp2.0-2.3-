//
//  SheShouBangTableViewCell.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/1/12.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "SheShouBangTableViewCell.h"

@implementation SheShouBangTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(SheShouBangModel *)model{
    
    if (_model != model) {
        _model = model;

        _rankLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.c1];
        _playerLabel.text = _model.c2;
        _goalLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.c4];
        _assistLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.c5];
        _teamLabel.text = _model.c3;
        
        _rankLabel.textColor = [UIColor whiteColor];
        _playerLabel.textColor = [UIColor whiteColor];
        _goalLabel.textColor = [UIColor whiteColor];
        _assistLabel.textColor = [UIColor whiteColor];
        _teamLabel.textColor = [UIColor whiteColor];
        //_loseLabel.textColor = [UIColor whiteColor];
    }
}


@end
