//
//  NotworkDataCell.m
//  YSObject
//
//  Created by Long on 2019/2/23.
//  Copyright © 2019 Long. All rights reserved.
//

#import "NotworkDataCell.h"
@interface NotworkDataCell ()
{
    UIImageView * _iconNone;
    
    UILabel * _lblNone;
}

@end

@implementation NotworkDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconNone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no-record"]];
        [_iconNone sizeToFit];
        [self.contentView addSubview:_iconNone];
        _iconNone.left = (UIScreenWidth - _iconNone.width)/2.0;
        _iconNone.top = self.contentView.height / 2 + 45;
        
        
        _lblNone = [UILabel initWithFrame:CGRectZero
                                  bgColor:[UIColor clearColor]
                                textColor:[UIColor colorWithRGBHex:0xaaaaaa]
                                     text:@"暂无订单"
                            textAlignment:NSTextAlignmentLeft
                                     font:[UIFont systemFontOfSize:15]];
        [_lblNone sizeToFit];
        [self.contentView addSubview:_lblNone];
        _lblNone.left = (UIScreenWidth - _lblNone.width)/2.0;
        _lblNone.top = _iconNone.bottom + 30;
    }
    return self;
}
@end
