//
//  Configure.h
//  安泰
//
//  Created by Long on 2019/2/22.
//  Copyright © 2019 Long. All rights reserved.
//

#ifndef Configure_h
#define Configure_h


//手机尺寸
#define is35InchDevice ([UIDevice currentDevice].screenType==UIDEVICE_35INCH)
#define is4InchDevice ([UIDevice currentDevice].screenType==UIDEVICE_4INCH)
#define is47InchDevice ([UIDevice currentDevice].screenType==UIDEVICE_4_7_INCH)
#define is55InchDevice ([UIDevice currentDevice].screenType==UIDEVICE_5_5_INCH)
#define is58InchDevice ([UIDevice currentDevice].screenType==UIDEVICE_5_8_INCH) || ([UIDevice currentDevice].screenType==UIDEVICE_6_5_INCH)

//运行环境
#define isRunningOnIOS8           [[UIDevice currentDevice] isIOS8]
#define isRunningOnIOS9           [[UIDevice currentDevice] isIOS9]
#define isRunningOnIOS10          [[UIDevice currentDevice] isIOS10]
#define isRunningOnIOS11          [[UIDevice currentDevice] isIOS11]

//宽、高、比例
#define UIScreenWidth  [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIScreenScale  (NSInteger)[UIScreen mainScreen].scale

//适配
#define kScreenWidthRatio           (UIScreenWidth / (isIphoneDevice?375.0f:768.0f))
#define kScreenHeightRatio          (UIScreenHeight / (isIphoneDevice?667.0f:1136.0f))
#define AdaW(x)                     (x * kScreenWidthRatio)
#define AdaH(x)                     (x * kScreenHeightRatio)

//部分机型高度宏定义
#define iOSNavHeight              (is58InchDevice?88:64)
#define IOSTabBarHeight           (is58InchDevice?83:49)
#define iOSStatusBarHeight        (is58InchDevice?44:20)
#define iphoneXBottomAreaHeight   (is58InchDevice?34:0)
#define iOSTopHeight              (is58InchDevice?24:0)
#define IOSStatusBottom           (is58InchDevice?34:20)








#endif /* Configure_h */
