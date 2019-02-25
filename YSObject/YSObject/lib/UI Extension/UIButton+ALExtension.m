//
//  UIButton+ALExtension.m
//  ALExtension
//
//  Created by Albert Lee on 8/25/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "UIButton+ALExtension.h"
#import <objc/runtime.h>
static char UIButtonALExtensionTagString;
static char UIButtonALExtensionCustomImageView;
static char UIButtonALExtensionCustomTitleLabel;
static char UIButtonALExtensionCustomTitleLabel2;
@implementation UIButton (ALExtension)
@dynamic tagString,lblCustom,lblCustom2;

-(void)setTagString:(NSString *)tagString
{
  objc_setAssociatedObject(self, &UIButtonALExtensionTagString, tagString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)tagString
{
  return objc_getAssociatedObject(self, &UIButtonALExtensionTagString);
}

-(void)setCustomImageView:(UIImageView *)customImageView
{
  objc_setAssociatedObject(self, &UIButtonALExtensionCustomImageView, customImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImageView *)customImageView
{
  return objc_getAssociatedObject(self, &UIButtonALExtensionCustomImageView);
}

- (void)setLblCustom:(UILabel *)lblCustom{
  objc_setAssociatedObject(self, &UIButtonALExtensionCustomTitleLabel, lblCustom, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLblCustom2:(UILabel *)lblCustom2{
  objc_setAssociatedObject(self, &UIButtonALExtensionCustomTitleLabel2, lblCustom2, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)lblCustom{
  return objc_getAssociatedObject(self, &UIButtonALExtensionCustomTitleLabel);
}

- (UILabel *)lblCustom2{
  return objc_getAssociatedObject(self, &UIButtonALExtensionCustomTitleLabel2);
}

@dynamic hitTestEdgeInsets;

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
  NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
  objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)hitTestEdgeInsets {
  NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
  if(value) {
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero; [value getValue:&edgeInsets]; return edgeInsets;
  }else {
    return UIEdgeInsetsZero;
  }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
  if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) ||       !self.enabled || self.hidden) {
    return [super pointInside:point withEvent:event];
  }
  
  CGRect relativeFrame = self.bounds;
  CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
  
  return CGRectContainsPoint(hitFrame, point);
}

- (void)arrangeCustomSubviewToCenterWithGap:(CGFloat)gap{
  [self.customImageView sizeToFit];
  [self.lblCustom sizeToFit];
  if (self.width == 0) {
    self.width = self.customImageView.width + gap + self.lblCustom.width;
  }
  self.customImageView.left = (self.width-self.customImageView.width-gap-self.lblCustom.width)/2.0;
  self.customImageView.top = (self.height-self.customImageView.height)/2.0;
  self.lblCustom.left = self.customImageView.right+gap;
  self.lblCustom.top = (self.height-self.lblCustom.height)/2.0;
}

- (void)setImage:(UIImage *)image text:(NSString *)text textColorHex:(UInt32)textColorHex fontSize:(NSInteger)fontSize gap:(CGFloat)gap{
  [self.customImageView removeFromSuperview];
  [self.lblCustom removeFromSuperview];
  self.customImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
  self.customImageView.image = image;
  [self addSubview:self.customImageView];
  
  self.lblCustom = [UILabel initWithFrame:CGRectZero
                                  bgColor:[UIColor clearColor]
                                textColor:[UIColor colorWithRGBHex:textColorHex]
                                     text:text
                            textAlignment:NSTextAlignmentLeft
                                     font:[UIFont fontWithName:@"Arial-BoldMT" size:fontSize]];
  [self addSubview:self.lblCustom];
  [self arrangeCustomSubviewToCenterWithGap:gap];
}

- (void)setImage:(UIImage *)image text:(NSString *)text textColorHex:(UInt32)textColorHex fontSize:(NSInteger)fontSize{
  [self.customImageView removeFromSuperview];
  [self.lblCustom removeFromSuperview];
  self.customImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
  self.customImageView.image = image;
  [self addSubview:self.customImageView];
  
  self.lblCustom = [UILabel initWithFrame:CGRectZero
                                  bgColor:[UIColor clearColor]
                                textColor:[UIColor colorWithRGBHex:textColorHex]
                                     text:text
                            textAlignment:NSTextAlignmentLeft
                                     font:[UIFont systemFontOfSize:fontSize]];
  [self addSubview:self.lblCustom];
}

- (void)gradientLayer:(NSArray *)colors{
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.3),@(1.0)];
    [gradientLayer setColors:colors];
    [self.layer addSublayer:gradientLayer];
}
@end
