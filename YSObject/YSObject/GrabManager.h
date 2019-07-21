//
//  GrabManager.h
//  YSObject
//
//  Created by MaYiKe on 2019/7/12.
//  Copyright © 2019 Long. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GrabManager : NSObject

+(GrabManager*)sharedInstance;

@property(nonatomic,assign)NSString * currentCarId;

@end

NS_ASSUME_NONNULL_END
