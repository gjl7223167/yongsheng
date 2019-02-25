//
//  ALErrorItem.h
//  pandora
//
//  Created by lixin on 14/12/16.
//  Copyright (c) 2014年 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseItem.h"

@interface ErrorItem : BaseItem
@property(nonatomic, strong)NSString     *errmsg; //错误信息
@property(nonatomic, strong)NSString     *usermsg;//给用户提示信息
@property(nonatomic, strong)NSNumber     *errorno;//错误号

@property(nonatomic, strong)NSNumber     *status;//量化状态码

@end
