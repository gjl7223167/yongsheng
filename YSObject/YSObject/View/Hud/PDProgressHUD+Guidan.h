//
//  PDProgressHUD+Guidan.h
//  AntLive
//
//  Created by Long on 2018/6/11.
//  Copyright © 2018年 Baobao. All rights reserved.
//

#import "PDProgressHUD.h"
typedef enum: NSInteger{
    Location_UP = 0,
    Location_LEFT,
    Location_DOWN,
    Location_RIGHT,
    Location_Empty,
    Location_Right_Bottom,
}KrcLocation;

@interface PDProgressHUD (Guidan)
/**
 新手引导
 
 @param titles 引导页标题集合
 @param points 标题位置集合（NSValue）
 */
+(void)showTipsTitles:(NSArray<NSString *> *)titles points:(NSArray<NSValue *> *)points location:(NSArray<NSNumber* > *)location supView:(UIView *)supView FinishBlock:(void(^)(void))finishBlock;
@end
