//
//  LongDistanceBusTableViewCell.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/22.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "LongDistanceBusTableViewCell.h"

@implementation LongDistanceBusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(LongDistanceBusModel *)model{
    
    if (_model != model) {
        _model = model;
        _busStation.text = [NSString stringWithFormat:@"始发站: %@",_model.start];
        _time.text = [NSString stringWithFormat:@"出发时间: %@",_model.date];
        _price.text = [NSString stringWithFormat:@"价格: %@",_model.price];
    }
}

@end
