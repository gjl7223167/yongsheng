//
//  logModel.m
//  YSObject
//
//  Created by GJL on 2019/7/6.
//  Copyright © 2019 Long. All rights reserved.
//

#import "logModel.h"

@implementation logModel


+(NSArray *)appLocAry{
    NSString * string = @"lng=114.592174&lat=39.840322#lng=114.578843&lat=39.839297#lng=114.578286&lat=39.847579#lng=114.578268&lat=39.844269#lng=114.594581&lat=39.840377#lng=114.593611&lat=39.846998#lng=114.593611&lat=39.846998#lng=114.593611&lat=39.846998#lng=114.59742&lat=39.845973#lng=114.599594&lat=39.833604#lng=114.58956&lat=39.849608#";
    
    NSArray * locAry = [string componentsSeparatedByString:@"#"];
    return locAry;
    
}

@end
