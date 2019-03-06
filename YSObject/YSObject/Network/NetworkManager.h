//
//  NetworkManager.h
//  YSObject
//
//  Created by Long on 2019/2/22.
//  Copyright © 2019 Long. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^NetworkManagerDicBlock)(NSDictionary *resultDic);
typedef void (^NetworkManagerErrorBlock)(NSError* error, NSDictionary * __nullable resultDic);


@interface NetworkManager : NSObject
+ (NetworkManager *)shareInstance;

- (void)functionAPI:(NSString     *)api
             params:(NSDictionary *)params
               data:(nullable NSData *)data
            dataKey:(nullable NSString     *)dataKey
             Method:(NSString*)method
     completeHandle:(NetworkManagerDicBlock)completionHandler
       errorHandler:(NetworkManagerErrorBlock)errorHandler;

- (void)functionAPI:(NSString     *)api
             params:(NSDictionary *)params
             Method:(NSString*)method
     completeHandle:(NetworkManagerDicBlock)completionHandler
       errorHandler:(NetworkManagerErrorBlock)errorHandler;




-(void)testNetwork;
@end

NS_ASSUME_NONNULL_END
