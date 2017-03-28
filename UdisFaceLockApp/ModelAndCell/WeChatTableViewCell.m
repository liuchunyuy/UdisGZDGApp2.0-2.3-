//
//  WeChatTableViewCell.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/12/21.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "WeChatTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation WeChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(WeChatModel *)model{
    
    if (_model != model) {
        _model = model;
        _title.text = [NSString stringWithFormat:@"%@\n ",_model.title];
        _title.numberOfLines = 0;
        _source.text = _model.source;
        [_firstImg sd_setImageWithURL:[NSURL URLWithString:_model.firstImg] placeholderImage:[UIImage imageNamed:@"moren1"]];
        //NSData * imageData = UIImageJPEGRepresentation(_firstImg.image,1);
        //NSLog(@"图片大小 %lu",[imageData length]/1000);
    }
}
@end
