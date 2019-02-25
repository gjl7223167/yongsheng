//
//  GuidanButton.h
//  AntLive
//
//  Created by Long on 2018/6/11.
//  Copyright © 2018年 Baobao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickActionBlock) (id obj);
@interface GuidanButton : UIButton
@property (nonatomic,strong)ClickActionBlock caBlock;
- (void)initWithBlock:(ClickActionBlock)clickBlock for:(UIControlEvents)event;

@end
