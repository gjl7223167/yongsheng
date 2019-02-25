//
//  Utility.m
//  YSObject
//
//  Created by Long on 2019/2/23.
//  Copyright © 2019 Long. All rights reserved.
//

#import "Utility.h"

@implementation Utility
+ (UIFont *)antLivePingFangSCSemiboldWithSize:(CGFloat)fontSize{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize];
    return font;
}
+ (UIFont *)antLivePingFangSCMediumWithSize:(CGFloat)fontSize{
    UIFont *font = [UIFont fontWithName:@"PingFang-SC-Medium" size:fontSize];
    return font;
}
+ (UIFont *)antLivePingFangSCRegularWithSize:(CGFloat)fontSize{
    UIFont *font = [UIFont fontWithName:@"PingFang-SC-Regular" size:fontSize];
    return font;
}
+ (UIFont *)antLivePingFangSCLightWithSize:(CGFloat)fontSize{
    UIFont *font = [UIFont fontWithName:@"PingFang-SC-Light" size:fontSize];
    return font;
}
@end
