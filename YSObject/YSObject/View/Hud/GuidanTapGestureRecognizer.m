//
//  GuidanTapGestureRecognizer.m
//  AntLive
//
//  Created by Long on 2018/6/11.
//  Copyright © 2018年 Baobao. All rights reserved.
//

#import "GuidanTapGestureRecognizer.h"

@implementation GuidanTapGestureRecognizer
- (void)initWithBlock:(ClickActionBlock)clickActionBlock{
    
    [self addTarget:self action:@selector(goAction:)];
    self.caBlock = clickActionBlock;
}

- (void)goAction:(UIButton *)btn{
    
    self.caBlock(btn);
}

@end
