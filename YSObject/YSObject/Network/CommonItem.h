//
//  ALCommonItem.h
//  pandora
//
//  Created by lixin on 14/12/17.
//  Copyright (c) 2014年 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseItem.h"
#import "ErrorItem.h"

@interface CommonItem : BaseItem
@property(nonatomic, strong)ErrorItem *error;
@end
