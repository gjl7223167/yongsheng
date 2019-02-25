//
//  GuidanButton.m
//  AntLive
//
//  Created by Long on 2018/6/11.
//  Copyright © 2018年 Baobao. All rights reserved.
//

#import "GuidanButton.h"

@implementation GuidanButton


- (void)initWithBlock:(ClickActionBlock)clickActionBlock for:(UIControlEvents)event{
    
    [self addTarget:self action:@selector(goAction:) forControlEvents:event];
    
    self.caBlock = clickActionBlock;
}

- (void)goAction:(UIButton *)btn{
    
    self.caBlock(btn);
}



@end
