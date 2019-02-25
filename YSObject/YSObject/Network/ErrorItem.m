//
//  ALErrorItem.m
//  pandora
//
//  Created by lixin on 14/12/16.
//  Copyright (c) 2014年 Albert Lee. All rights reserved.
//

#import "ErrorItem.h"

@implementation ErrorItem

- (id)init{
    self = [super init];
    if (self) {
        [self addMappingRuleProperty:@"errmsg" pathInJson:@"errmsg"];
        [self addMappingRuleProperty:@"usermsg" pathInJson:@"usermsg"];
        [self addMappingRuleProperty:@"errorno" pathInJson:@"errno"];
        [self addMappingRuleProperty:@"status" pathInJson:@"status"];
    }
    return self;
}

- (void)dealloc{
    self.errmsg = nil;
    self.usermsg = nil;
    self.errorno = nil;
}

@end
