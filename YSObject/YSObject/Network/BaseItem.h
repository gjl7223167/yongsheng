//
//  ALBaseItem.h
//  pandora
//
//  Created by lixin on 14/12/16.
//  Copyright (c) 2014年 Albert Lee. All rights reserved.
//

#ifndef pandora_ALBaseItem_h
#define pandora_ALBaseItem_h
#import <Foundation/Foundation.h>

@interface BaseItem : NSObject <NSCoding>{
    NSMutableDictionary *_jsonDataMap;
    NSMutableDictionary *_jsonArrayClassMap;
}

// 需要动态计算cell高度的list，需要cache cellheight，提升效率。参与序列化
@property (nonatomic, assign) CGFloat cellHeight;

- (id)init;
- (id)initWithData:(id)data;
+ (id)itemWithData:(id)data;
- (id)setData:(id)data;

+(void)setObj:(id)data forKey:(NSString *)aKey;
+(id)objectForKey:(NSString*)key;
+(void)removeObjForKey:(NSString *)key;
+(void)removeAll;
//子类继承在解析完json以后的一些数据逻辑处理
-(void)handleDataAfterParse;

/* Property-JSON映射规则，须在子类Init函数中设定 */

// property中如有包含PDBaseListItem对象的数组，需要设定此规则
- (void)addMappingRuleArrayProperty:(NSString*)propertyName class:(Class)cls;
// 所有需要映射的property都需要设定此规则
- (void)addMappingRuleProperty:(NSString*)propertyName pathInJson:(NSString*)path;


//获得数据的key对应的Path
- (NSString *)getPahtForDataMapWithKey:(NSString *)aKey;
//获取key 为aKey的类名
- (NSString *)mappingRuleWithKey:(NSString *)aKey;
//设置filed的name
- (void)setfieldName:(NSString*)name fieldClassName:(NSString*)className value:(id)value;

@end
#endif
