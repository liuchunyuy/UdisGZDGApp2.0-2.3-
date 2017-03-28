//
//  NewsTableViewCell.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/20.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TopLeftLabel.h" //暂时没用
@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(NewsModel *)model{
    
    if (_model != model) {
        _model = model;
        _titleLabel.text = [NSString stringWithFormat:@"%@\n ",_model.title];
        _titleLabel.numberOfLines = 0;
        _dateLabel.text = _model.date;
        _author_name.text = _model.author_name;
        _realtypeLabel.text = _model.realtype;
        [_thumbnail_pic_s sd_setImageWithURL:[NSURL URLWithString:_model.thumbnail_pic_s] placeholderImage:[UIImage imageNamed:@"moren1"]];
       // NSData * imageData = UIImageJPEGRepresentation(_thumbnail_pic_s.image,1);
       // NSLog(@"图片大小 %lu",[imageData length]/1000);        
    }
}

@end
