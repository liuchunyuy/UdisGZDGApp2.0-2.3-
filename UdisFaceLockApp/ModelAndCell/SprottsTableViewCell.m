//
//  SprottsTableViewCell.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 2017/1/5.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "SprottsTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation SprottsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(SoportsModel *)model{
    
    if (_model != model) {
        _model = model;
        
        _C2C3Label.text = [NSString stringWithFormat:@"%@",_model.c2];
        _C3Label.text = [NSString stringWithFormat:@"%@",_model.c3];
        //_c4T1Button.titleLabel.text = _model.c4T1;
        [_c4T1Button setTitle:_model.c4T1 forState:UIControlStateNormal];
        _c4T1Button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_c4T1URLImage sd_setImageWithURL:[NSURL URLWithString:_model.c4T1URL] placeholderImage:nil];
        _c4RLabel.text = _model.c4R;
        //_c4T2Button.titleLabel.text = _model.c4T2;
        [_c4T2Button setTitle:_model.c4T2 forState:UIControlStateNormal];
        _c4T2Button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_c4T2URLImage sd_setImageWithURL:[NSURL URLWithString:_model.c4T2URL] placeholderImage:nil];
        //NSData * imageData = UIImageJPEGRepresentation(_firstImg.image,1);
        //NSLog(@"图片大小 %lu",[imageData length]/1000);
    }
}

@end
