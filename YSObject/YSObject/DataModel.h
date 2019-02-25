//
//  DataModel.h
//  YSObject
//
//  Created by Long on 2019/2/23.
//  Copyright © 2019 Long. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "Id":235813,
 "OrderNo":"119",
 "CarNo":"冀GTJ189",
 "VoiceFileMinute":8,
 "CustomerPhone":"13623363999",
 "CustomerId":17899,
 "VoiceFiles":"http://183.196.249.184:9002/antai\\20192\23\a5de832c-6845-474b-9fd0-dcc47eba5180.mp3",
 "CreateDate":"2019-02-23T10:56:18",
 "CustomerStarPlace":null,
 "CustomerEndPlace":null,
 "OrderLat":null,
 "OrderLng":null,
 "Status":1,
 "LngLat":"114.579193-39.839547",
 "OrderType":1,
 "Phone":"13784554889"
 */
NS_ASSUME_NONNULL_BEGIN

@interface DataModel : BaseItem
@property(nonatomic,strong)NSNumber * bid;
@property(nonatomic,strong)NSNumber * OrderNo;
@property(nonatomic,strong)NSNumber * VoiceFileMinute;
@property(nonatomic,strong)NSNumber * CustomerId;
@property(nonatomic,strong)NSNumber * Status;
@property(nonatomic,strong)NSNumber * OrderType;
@property(nonatomic,strong)NSNumber * Phone;

@property(nonatomic,strong)NSString * CustomerPhone;
@property(nonatomic,strong)NSString * CarNo;
@property(nonatomic,strong)NSString * VoiceFiles;
@property(nonatomic,strong)NSString * CreateDate;
@property(nonatomic,strong)NSString  * CustomerStarPlace;
@property(nonatomic,strong)NSString  * CustomerEndPlace;
@property(nonatomic,strong)NSString  * OrderLat;
@property(nonatomic,strong)NSString  * OrderLng;
@property(nonatomic,strong)NSString  * LngLat;


@end

NS_ASSUME_NONNULL_END
