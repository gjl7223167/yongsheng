//
//  myTableViewCell.m
//  YSObject
//
//  Created by Long on 2019/2/23.
//  Copyright © 2019 Long. All rights reserved.
//

#import "myTableViewCell.h"

#import "DataModel.h"

@interface myTableViewCell ()
{
    UILabel * _lblOrderNo; //当天叫单次数
    UILabel * _lblCarNo;   //当前抢单车牌号
    UILabel * _lblCreateDate; //当前叫单时间
    UILabel * _lblStatus; //当前单是否被抢
    UILabel * _lblLngLat; //当前司机地理位置
    UIButton * _btnCustomerPhone;//乘客手机号
    UIImageView * _iconImage;
    UIImageView * _backImage;  //是否为自己抢单背景图
    
    DataModel * myModel;
 
    UIView * _lblLine;
}
@end

@implementation myTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [[UIColor colorWithRGBHex:0xFFFFFF] colorWithAlphaComponent:0.7];

        _lblOrderNo = [UILabel initWithFrame:CGRectZero
                                     bgColor:[UIColor clearColor]
                                   textColor:[UIColor colorWithRGBHex:0x000000]
                                        text:@"当前叫单次数"
                               textAlignment:NSTextAlignmentLeft
                                        font:[Utility antLivePingFangSCMediumWithSize:17]];
        _lblOrderNo.left =  22;
        _lblOrderNo.top = 15;
        
        
        _lblCarNo = [UILabel initWithFrame:CGRectZero
                                     bgColor:[UIColor clearColor]
                                   textColor:[UIColor colorWithRGBHex:0x888888]
                                        text:@"抢单车牌号"
                               textAlignment:NSTextAlignmentLeft
                                        font:[Utility antLivePingFangSCRegularWithSize:15]];
        _lblCarNo.left = 22;
        _lblCarNo.top = _lblOrderNo.bottom + 20;
        
        _lblLngLat = [UILabel initWithFrame:CGRectZero
                                   bgColor:[UIColor clearColor]
                                 textColor:[UIColor colorWithRGBHex:0x888888]
                                      text:@"乘客地理位置"
                             textAlignment:NSTextAlignmentLeft
                                      font:[Utility antLivePingFangSCRegularWithSize:15]];
        _lblLngLat.left = 22;
        _lblLngLat.top = _lblCarNo.bottom + 10;
        
        _lblStatus = [UILabel initWithFrame:CGRectZero
                                    bgColor:[UIColor clearColor]
                                  textColor:[UIColor colorWithRGBHex:0x6B6B6B]
                                       text:@"当前是否被抢"
                              textAlignment:NSTextAlignmentLeft
                                       font:[Utility antLivePingFangSCRegularWithSize:13]];
        _lblStatus.right = UIScreenWidth - 22;
        _lblStatus.top = _lblCarNo.top;
        
        
        _lblCreateDate = [UILabel initWithFrame:CGRectZero
                                    bgColor:[UIColor clearColor]
                                  textColor:[UIColor colorWithRGBHex:0x888888]
                                       text:@"当前叫单时间"
                              textAlignment:NSTextAlignmentLeft
                                       font:[Utility antLivePingFangSCRegularWithSize:15]];
        _lblCreateDate.left = 22;
        _lblCreateDate.top = _lblLngLat.bottom + 5;
        
        _btnCustomerPhone = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnCustomerPhone.lblCustom = [UILabel initWithFrame:CGRectZero
                                                    bgColor:[UIColor clearColor]
                                                  textColor:[UIColor colorWithRGBHex:0x888888]
                                                       text:@""
                                              textAlignment:NSTextAlignmentLeft
                                                       font:[Utility antLivePingFangSCRegularWithSize:15]];
        [_btnCustomerPhone addSubview:_btnCustomerPhone.lblCustom];
        [_btnCustomerPhone addTarget:self action:@selector(iphonePersion:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        _iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_icon"]];
        [_iconImage sizeToFit];
        _iconImage.centerY = _btnCustomerPhone.centerY;
        _iconImage.left = _btnCustomerPhone.right + 5;
        
        [self.contentView addSubview:_lblOrderNo];
        [self.contentView addSubview:_lblCarNo];
        [self.contentView addSubview:_lblCreateDate];
        [self.contentView addSubview:_lblStatus];
        [self.contentView addSubview:_lblLngLat];
        [self.contentView addSubview:_btnCustomerPhone];
        [self.contentView addSubview:_iconImage];

        _lblLine = [[UIView alloc] initWithFrame:CGRectMake(22, 0, UIScreenWidth - 22 * 2, 1)];
        _lblLine.backgroundColor = [UIColor colorWithRGBHex:0xf4f4fa];
        [self.contentView addSubview:_lblLine];
        
        
        _backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wo_select_icon"]];
        [_backImage sizeToFit];
        [self.contentView addSubview:_backImage];
        _backImage.right = self.contentView.width - 12;
        _backImage.bottom = self.contentView.height - 10;
        _backImage.hidden = YES;
    }
    return self;
}


+(instancetype)defaultCell{
    myTableViewCell *cell = [[myTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"CELLID%@",NSStringFromClass([self class])]];
    return cell;
}


- (void)setupCellForModel:(id )item{
        if ([item isKindOfClass:[DataModel class]]) {
        CGFloat selfHight = 0;
        
        DataModel *modl = (DataModel *)item;
        myModel = modl;
        
        _lblOrderNo.text = [NSString stringWithFormat:@"订单:%@",[modl.OrderNo stringValue]];
        [_lblOrderNo sizeToFit];
        _lblOrderNo.left = 22;
        _lblOrderNo.top = 15;
            
        
        if ([modl.Status boolValue]) {
            _lblStatus.text = @"已被抢";
            _lblStatus.textColor = [UIColor colorWithRGBHex:0xec384c];
            _lblCarNo.text = [NSString stringWithFormat:@"抢单司机:%@",modl.CarNo];

        }else{
            _lblStatus.text = @"叫单中...";
            _lblStatus.textColor = [UIColor colorWithRGBHex:0x00c074];
            _lblCarNo.text = [NSString stringWithFormat:@"....."];
        }
            
        if ([modl.Status boolValue]) {
            if ([modl.CarNo isEqualToString:@"冀GTJ229"]) {
                _backImage.right = self.contentView.width - 12;
                _backImage.bottom = self.contentView.height - 10;
                _backImage.hidden = NO;
            }else{
                _backImage.hidden = NO;
            }
        }
            
            
        [_lblCarNo sizeToFit];
        _lblCarNo.left = 22;
        _lblCarNo.top = _lblOrderNo.bottom + 20;
            
        [_lblStatus sizeToFit];
        _lblStatus.right = UIScreenWidth - 22;
        _lblStatus.top = _lblCarNo.top;
            
        _lblLngLat.text =[NSString stringWithFormat:@"乘客地理位置 : %@",modl.LngLat?modl.LngLat:@"获取中"];
        [_lblLngLat sizeToFit];
        _lblLngLat.left = 22;
        _lblLngLat.top = _lblCarNo.bottom + 10;
        
        _lblCreateDate.text = [NSString stringWithFormat:@"订单时间:%@",modl.CreateDate];
        [_lblCreateDate sizeToFit];
        _lblCreateDate.left = 22;
        _lblCreateDate.top = _lblLngLat.bottom + 10;
        
        NSString * tempStr = [NSString stringWithFormat:@"乘客手机号 : %@",modl.CustomerPhone];
        NSAttributedString * attributeStr = [tempStr attributedStringWithFont:[Utility antLivePingFangSCRegularWithSize:15] textColor:[UIColor colorWithRGBHex:0x888888] selStr:modl.CustomerPhone selFont:[Utility antLivePingFangSCRegularWithSize:15] selColor:[UIColor colorWithRGBHex:0x000000]];
        _btnCustomerPhone.lblCustom.attributedText = attributeStr;
        [_btnCustomerPhone.lblCustom sizeToFit];
        _btnCustomerPhone.bounds = _btnCustomerPhone.lblCustom.bounds;
        _btnCustomerPhone.top = _lblCreateDate.bottom + 10;
        _btnCustomerPhone.left = 22;
        
        _iconImage.centerY = _btnCustomerPhone.centerY;
        _iconImage.left = _btnCustomerPhone.right + 5;
            
            
        _lblLine.top = _btnCustomerPhone.bottom + 9;
            
        selfHight = _btnCustomerPhone.bottom + 20;
        self.height = selfHight;
    }
}


+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)model{
    myTableViewCell * cell = [tableView ant_rowHeightCalculateCellForClass:self];
    [cell setupCellForModel:model];
    return cell.height;
}


-(void)iphonePersion:(UIButton *)sender{
    
    NSString * iphoneStr = [NSString stringWithFormat:@"telprompt://%@",myModel.CustomerPhone];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:iphoneStr] options:@{} completionHandler:nil];
}

@end
