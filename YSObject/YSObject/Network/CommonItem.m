//
//  ALCommonItem.m
//  pandora
//
//  Created by lixin on 14/12/17.
//  Copyright (c) 2014年 Albert Lee. All rights reserved.
//

#import "CommonItem.h"

@implementation CommonItem
- (id)init{
    self = [super init];
    if (self) {
        [self addMappingRuleProperty:@"error" pathInJson:@"error"];
        [self addMappingRuleArrayProperty:@"error" class:[ErrorItem class]];
    }
    return self;
}

- (void)dealloc{
    self.error = nil;
}
@end
