//
//  NewMessageTableViewCell.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/9/12.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "NewMessageTableViewCell.h"

@implementation NewMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(NewMessageModel *)model{
    
    if (_model != model) {
        _model = model;
        
        NSString *str = [_model.message stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *str1 = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
       // NSString *messageStr = [str1 substringFromIndex:1];
        //NSString *messageStr2 = [messageStr substringToIndex:(messageStr.length-2)];
        //NSLog(@"-----message str------ is %@", messageStr2);
       // NSLog(@"-----message str lentgh  is---%ld", (unsigned long)messageStr2.length);
        _messageLabel.text = str1;
        _datetimeLabel.text = _model.datetime;
        _messageLabel.numberOfLines = 0;
        [_image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_model.messageImg]]];
    }
}

@end
