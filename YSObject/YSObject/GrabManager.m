//
//  GrabManager.m
//  YSObject
//
//  Created by MaYiKe on 2019/7/12.
//  Copyright © 2019 Long. All rights reserved.
//

#import "GrabManager.h"

@implementation GrabManager

+(GrabManager*)sharedInstance{
    static GrabManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GrabManager alloc] init];
    });
    return manager;
}

-(instancetype)initCarID{
    if (self = [super init]) {
        _currentCarId = @"129";
    }
    return self;
}







@end
