//
//  UIView+CornerExtension.h
//  AntLive
//
//  Created by Long on 2018/3/31.
//  Copyright © 2018年 Baobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CornerExtension)
-(void)layerWithRadio:(CGFloat )value AndColor:(UIColor *)color;
+(CAShapeLayer *) layerWithFrame:(CGRect)frame Radiu:(CGFloat)value AndColor:(UIColor *)color;
-(void)setCornerWithRadio:(CGFloat )value AndColor:(UIColor *)color;
-(void)setCornerWithRadio:(CGFloat )value borderColor:(UIColor *)color;
-(BOOL)isDisplayedInScreen;
+(BOOL)isTopViewWithSelf:(UIView *)view;
@end
