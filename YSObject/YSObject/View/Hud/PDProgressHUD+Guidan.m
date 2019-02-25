//
//  PDProgressHUD+Guidan.m
//  AntLive
//
//  Created by Long on 2018/6/11.
//  Copyright © 2018年 Baobao. All rights reserved.
//

#import "PDProgressHUD+Guidan.h"
#import "GuidanButton.h"
#import "GuidanTapGestureRecognizer.h"
#import "Masonry.h"
@implementation PDProgressHUD (Guidan)

+(void)showTipsTitles:(NSArray<NSString *> *)titles points:(NSArray<NSValue *> *)points location:(NSArray<NSNumber *> *)location supView:(UIView *)supView FinishBlock:(void (^)(void))finishBlock{
    // 判断tips是否合法
    if (MIN(titles.count, points.count) == 0) {
        return;
    }
    // 背景View
    UIView *bigView = [[UIView alloc] init];
    bigView.tag = 404001;
    if (supView) {
        [supView addSubview:bigView];
    }else{
        [[[[UIApplication sharedApplication] delegate] window] addSubview:bigView];
    }
    
    [bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    // 添加第一个layer
    bigView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    NSString *str = titles[0];
    CGPoint point = [points[0] CGPointValue];
    [bigView addSubview:[PDProgressHUD labelWithString:str point:point location:[location[0]integerValue]]];
    
    // 界面事件
    GuidanTapGestureRecognizer *tap = [[GuidanTapGestureRecognizer alloc] init];
    
    [bigView addGestureRecognizer:tap];
    __block NSInteger index = 1;
    [tap initWithBlock:^(id obj) {
        if (index == MIN(titles.count, points.count)) {
            [bigView removeAllSubviews];
            [bigView removeFromSuperview];
            finishBlock();
            return ;
        }
        // 更改下标
        index++;
        // 直接将已经有的子layer删除
        [bigView removeAllSubviews];
        
        // 添加新的layer
        NSString *str = titles[index -1];
        CGPoint point = [points[index -1] CGPointValue];
        [bigView addSubview:[PDProgressHUD labelWithString:str point:point location:[location[index -1]integerValue]]];
    }];
}


+(UIView *)labelWithString:(NSString *)string point:(CGPoint)point location:(KrcLocation)location{
    UIView *view = [UIView new];
    CGFloat h = 0;
    CGFloat w = 0;
    

    
    UIFont *manFont = [UIFont boldSystemFontOfSize:17];
    UIFont *subFont = [UIFont systemFontOfSize:13];
    UIFont *defaFont = [UIFont systemFontOfSize:15];
    UILabel *la1;UILabel *la2;
    NSArray * ary = [string componentsSeparatedByString:@"\n"];
    NSInteger  count = ary.count;
    if (count == 1) {
        NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:ary[0] attributes:@{NSFontAttributeName:defaFont}];
        [attribute attributedDefaultColor:[UIColor whiteColor] selectText:@"点击卡片" selectColor:[UIColor colorWithRGBHex:0xFFE1BE]];
        la1 = [[UILabel alloc]initWithFrame:CGRectZero];
        la1.textAlignment = NSTextAlignmentCenter;
        la1.attributedText = attribute;
        [la1 sizeToFit];
        la1.left = 14;la1.top = 12;
        h = la1.bottom + 13;
    }else if (count == 2){
        la1 = [[UILabel alloc]initWithFrame:CGRectZero];
        la1.font = manFont;
        la1.textColor = [UIColor whiteColor];
        la1.textAlignment = NSTextAlignmentCenter;
        la1.text = ary[0];
        la1.left = 14;la1.top = 8;
        [la1 sizeToFit];
        
        la2 = [[UILabel alloc]initWithFrame:CGRectZero];
        la2.font = subFont;
        la2.textColor = [UIColor colorWithRGBHex:0xFFEAD3];
        la2.textAlignment = NSTextAlignmentCenter;
        la2.text = ary[1];
        [la2 sizeToFit];
        la2.left = 14;la2.top = la1.bottom + 4;
        h = la2.bottom + 13;
    }

    CGSize size = CGSizeMake(MAX(la1.width, la2.width) + 26, h);
    w = size.width;
    
    CGRect viewFrame = CGRectMake(point.x, point.y, w, h + 4);
    
    UIImageView *imageView;
    UIImageView *imageIcon;
    UIImage*image;
    UIEdgeInsets insets;
    // 三角的位置
    
    if (location == Location_UP) {
        image = [UIImage imageNamed:@"guide_up"];
        insets =UIEdgeInsetsMake(26,40,26,26);
        
        la1.top = 18;la2.top = la1.bottom + 4;
        imageIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guide_icon"]];
        [imageIcon sizeToFit];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w + imageIcon.width, h + 20)];
        imageIcon.left = w;imageIcon.bottom = imageView.bottom - 10 ;imageIcon.right = imageView.right - 15;
    }else if (location == Location_DOWN){
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h + 18)];
        image = [UIImage imageNamed:@"guide_bottom"];
        insets =UIEdgeInsetsMake(20,40,26,20);
        if (count==1) {
            la1.top = 14;
        }else{
           la1.top = 12;la2.top = la1.bottom + 4;
        }
        
    }else if (location == Location_LEFT || location == Location_RIGHT) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h + 14)];
        image = [UIImage imageNamed:@"guide_left"];
        insets =UIEdgeInsetsMake(40,24,24,26);
    }else if (location == Location_Empty){
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h + 14)];
        image = [UIImage imageNamed:@"guide_empty"];
        insets =UIEdgeInsetsMake(20,20,20,26);
    }else if (location == Location_Right_Bottom){
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h + 14)];
        image = [UIImage imageNamed:@"guide_bottom"];
        insets =UIEdgeInsetsMake(20,10,26,40);
    }else{
        insets =UIEdgeInsetsMake(20,20,20,26);
    }
    
    UIImage*insetImage = [image resizableImageWithCapInsets:insets];
    imageView.image= insetImage;
    [view addSubview:imageView];
    view.frame = viewFrame;
    
    [view addSubview:la1];
    [view addSubview:la2];
    [view addSubview:imageIcon];
    return view;
}

@end
