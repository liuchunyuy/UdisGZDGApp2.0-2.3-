//
//  ExpressTimeTableViewCell.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/4/7.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "ExpressTimeTableViewCell.h"

#import "UILabel+LeftTopAlign.h"
@implementation ExpressTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ExpressTimeModel *)model{
    
    if (_model != model) {
        _model = model;
        
        _timeLabel.text = _model.time;
        _statueLabel.text = [NSString stringWithFormat:@"%@\n",_model.context];
        _statueLabel.numberOfLines = 0;
        
    }
}


@end
