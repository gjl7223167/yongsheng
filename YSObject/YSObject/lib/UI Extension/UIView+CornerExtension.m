//
//  UIView+CornerExtension.m
//  AntLive
//
//  Created by Long on 2018/3/31.
//  Copyright © 2018年 Baobao. All rights reserved.
//

#import "UIView+CornerExtension.h"
#define  kLineHeight  0.6

@implementation UIView (CornerExtension)
-(void)layerWithRadio:(CGFloat )value AndColor:(UIColor *)color{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(value,value)];//圆角大小
    CAShapeLayer * masLayere = [[CAShapeLayer alloc] init];
    masLayere.masksToBounds = YES;
    masLayere.frame = self.bounds;
    masLayere.fillColor = color.CGColor;
    masLayere.path  = maskPath.CGPath;
    [self.layer insertSublayer:masLayere atIndex:0];
}
+(CAShapeLayer *) layerWithFrame:(CGRect)frame Radiu:(CGFloat)value AndColor:(UIColor *)color{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(value,value)];//圆角大小u];
    CAShapeLayer * masLayere = [[CAShapeLayer alloc] init];
    masLayere.masksToBounds = YES;
    masLayere.frame = frame;
    masLayere.fillColor = color.CGColor;
    masLayere.path  = maskPath.CGPath;
    return masLayere;
}

-(void)setCornerWithRadio:(CGFloat )value AndColor:(UIColor *)color{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:value];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    maskLayer.fillColor =color.CGColor;
    [self.layer insertSublayer:maskLayer atIndex:0];
}


-(void)setCornerWithRadio:(CGFloat )value borderColor:(UIColor *)color{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:value];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    maskLayer.fillColor =[UIColor whiteColor].CGColor;
    maskLayer.borderWidth = kLineHeight;
    maskLayer.strokeColor =color.CGColor;
    [self.layer insertSublayer:maskLayer atIndex:0];
}

-(BOOL)isDisplayedInScreen{
        if(self == nil){
          return NO;
        }
        CGRect screenRect = [UIScreen mainScreen].bounds;
        //转换view对应window的Rect
        CGRect rect = [self convertRect:self.frame fromView:nil];
        if(CGRectIsEmpty(rect) || CGRectIsNull(rect)){
          return NO;
        }
        if(self.hidden){
          return NO;
        }
        if(self.superview == nil){
          return NO;
        }
        if(CGSizeEqualToSize(rect.size, CGSizeZero)){
          return NO;
        }
        //获取 该view 与window 交叉的Rect
        CGRect intersectionRect = CGRectIntersection(rect, screenRect);
        if(CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)){
          return NO;
        }
    return YES;
}

+(BOOL)isTopViewWithSelf:(UIView *)view{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    NSArray * aryView = [window subviews];
    UIView *topView = [aryView lastObject];
    if (aryView && aryView.count > 1) {
        if ([topView isEqual:view]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}


@end
