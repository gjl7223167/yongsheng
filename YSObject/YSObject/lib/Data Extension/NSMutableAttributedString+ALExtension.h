//
//  NSMutableAttributedString+ALExtension.h
//  AntLive
//
//  Created by Albert Lee on 19/03/2018.
//  Copyright © 2018 Baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (ALExtension)
- (void)addLineSpacing:(CGFloat)lineSpacing;
- (void)addLineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment;
- (void)addHeadIndent:(CGFloat)headIndent;
- (void)addParagraphSpacing:(CGFloat)lineSpacing AndLineSpacing:(CGFloat )lineSpa;
- (void)addWordSpacing:(CGFloat)wordSpacing;
- (CGSize)sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size lineBreakMode:(NSString *)str;
- (void)attributedWithFont:(UIFont *)dFont HighFont:(UIFont *)sFont SelectStr:(NSString *)sStr IsSeparated:(BOOL)isSep;
-(void)attributedDefaultColor:(UIColor *)defCol selectText:(NSString *)selStr selectColor:(UIColor *)selCor;
-(void)addAttributeStr:(NSString *)selStr Attribute:(NSDictionary *)dict;
@end
;
