//
//  scoketModel.h
//  YSObject
//
//  Created by Long on 2019/2/22.
//  Copyright © 2019 Long. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface scoketModel : NSObject
+ (scoketModel *) sharedInstance;

@property(nonatomic,assign)BOOL currentConnectStatus;

-(void)connect;
-(void)writeData:(NSString *)string;


//疯狂模式
-(void)crazyModel;
//正常模式
-(void)normalModel;

@end

NS_ASSUME_NONNULL_END
