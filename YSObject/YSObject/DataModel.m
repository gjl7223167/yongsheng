//
//  DataModel.m
//  YSObject
//
//  Created by Long on 2019/2/23.
//  Copyright © 2019 Long. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel
- (id)init{
    self = [super init];
    if (self) {
        [self addMappingRuleProperty:@"bid" pathInJson:@"Id"];
        [self addMappingRuleProperty:@"OrderNo" pathInJson:@"OrderNo"];
        [self addMappingRuleProperty:@"VoiceFileMinute" pathInJson:@"VoiceFileMinute"];
        [self addMappingRuleProperty:@"CustomerPhone" pathInJson:@"CustomerPhone"];
        [self addMappingRuleProperty:@"CustomerId" pathInJson:@"CustomerId"];
        [self addMappingRuleProperty:@"Status" pathInJson:@"Status"];
        [self addMappingRuleProperty:@"OrderType" pathInJson:@"OrderType"];
        [self addMappingRuleProperty:@"Phone" pathInJson:@"Phone"];
        [self addMappingRuleProperty:@"CarNo" pathInJson:@"CarNo"];
        [self addMappingRuleProperty:@"VoiceFiles" pathInJson:@"VoiceFiles"];

        [self addMappingRuleProperty:@"CreateDate" pathInJson:@"CreateDate"];
        [self addMappingRuleProperty:@"CustomerStarPlace" pathInJson:@"CustomerStarPlace"];
        [self addMappingRuleProperty:@"CustomerEndPlace" pathInJson:@"CustomerEndPlace"];
        [self addMappingRuleProperty:@"OrderLat" pathInJson:@"OrderLat"];
        [self addMappingRuleProperty:@"OrderLng" pathInJson:@"OrderLng"];
        [self addMappingRuleProperty:@"LngLat" pathInJson:@"LngLat"];

        
    }
    return self;
}
@end
