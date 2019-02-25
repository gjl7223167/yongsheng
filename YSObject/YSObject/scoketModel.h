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

@end

NS_ASSUME_NONNULL_END
