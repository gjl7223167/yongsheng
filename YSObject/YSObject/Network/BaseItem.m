//
//  ALBaseItem.m
//  pandora
//
//  Created by lixin on 14/12/16.
//  Copyright (c) 2014年 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseItem.h"
#import <objc/runtime.h>

#define PD_BASE_ITEM_CACHE_KEY @"BaseItemDataCache"

@interface BaseItem()
@end

@implementation BaseItem

static IDPCache* get_cache_handle()
{
  static IDPCache *idpCache;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    idpCache = [[IDPCache alloc] initWithNameSpace:PD_BASE_ITEM_CACHE_KEY storagePolicy:IDPCacheStorageDisk];
  });
  return idpCache;
}

+ (id)itemWithData:(id)data {
  return [[BaseItem alloc] initWithData:data];
}

- (id)init {
  if (self = [super init]) {
    self.cellHeight = -1.0;
    _jsonDataMap = [[NSMutableDictionary alloc] init];
    _jsonArrayClassMap = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (id)initWithData:(id)data {
  if (self = [self init]) {
    self.cellHeight = -1.0;
    [self setData:data];
  }
  return self;
}


+ (void)setObj:(id)data forKey:(NSString *)aKey{
  [get_cache_handle() setObj:data forKey:aKey];
}

+ (id)objectForKey:(NSString*)key{
  return [get_cache_handle() objectForKey:key];
}

+ (void)removeObjForKey:(NSString *)key{
  [get_cache_handle() removeObjcetForKey:key];
}

+ (void)removeAll{
  [get_cache_handle() removeAll];
}

// 反序列化自身包括子类
- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(self.class, &propertyCount);
    for (unsigned i = 0; i < propertyCount; i++) {
      objc_property_t property = propertyList[i];
      NSString * propertyName= [NSString stringWithUTF8String:property_getName(property)];
      @try {
        id value = [aDecoder decodeObjectForKey:propertyName];
        if (value) {
          [self setValue:value forKey:propertyName];
        }
      }@catch (NSException *exception) {
        NSLog(@"proprty is not KVC compliant: %@", propertyName);
      }
    }
    free(propertyList);
    self.cellHeight = [aDecoder decodeFloatForKey:@"cellHeight"];
  }
  return self;
}

// 序列化自身包括子类
- (void)encodeWithCoder:(NSCoder *)aCoder {
  unsigned int propertyCount = 0;
  objc_property_t *propertyList = class_copyPropertyList(self.class, &propertyCount);
  for (unsigned i = 0; i < propertyCount; i++) {
    objc_property_t property = propertyList[i];
    NSString * propertyName= [NSString stringWithUTF8String:property_getName(property)];
    @try {
      id value = [self valueForKey:propertyName];
      [aCoder encodeObject:value forKey:propertyName];
    }@catch (NSException *exception) {
      NSLog(@"proprty is not KVC compliant: %@", propertyName);
    }
  }
  free(propertyList);
  [aCoder encodeFloat:self.cellHeight forKey:@"cellHeight"];
}

- (id)setData:(id)data {
  [self parseData:data];
  return self;
}


- (void)addMappingRuleProperty:(NSString*)propertyName pathInJson:(NSString*)path{
  [_jsonDataMap setObject:path forKey:propertyName];
}

- (NSString *)getPahtForDataMapWithKey:(NSString *)aKey{
  if (aKey == nil){
    return nil;
  }
  return [_jsonDataMap safeStringObjectForKey:aKey];
}

- (NSString *)mappingRuleWithKey:(NSString *)aKey{
  if (aKey == nil){
    return nil;
  }
  return [_jsonArrayClassMap safeStringObjectForKey:aKey];
}

- (void)addMappingRuleArrayProperty:(NSString*)propertyName class:(Class)cls{
  [_jsonArrayClassMap setObject:NSStringFromClass(cls) forKey:propertyName];
}

- (BOOL)parseData:(NSDictionary *)data{
  if(![data isKindOfClass:[NSDictionary class]]){
    return NO;
  }
  Class cls = [self class];
  while (cls != [BaseItem class]){
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(cls, &propertyCount);//获取cls 类成员变量列表
    for (unsigned i = 0; i < propertyCount; i++) {
      objc_property_t property = propertyList[i];
      const char *attr = property_getAttributes(property); //取得这个变量的类型
      NSString *attrString = [NSString stringWithUTF8String:attr];
      NSString *typeAttr = [[attrString componentsSeparatedByString:@","] safeObjectAtIndex:0];
      if(typeAttr.length < 8) continue;
      NSString *typeString = [typeAttr substringWithRange:NSMakeRange(3, typeAttr.length - 4)];
      NSString *key = [NSString stringWithUTF8String:property_getName(property)];//取得这个变量的名称
      NSString* path = [_jsonDataMap safeStringObjectForKey:key];
      id value = [data objectAtPath:path];
      [self setfieldName:key fieldClassName:typeString value:value];
    }
    free(propertyList);
    cls = class_getSuperclass(cls);
  }
  //更多处理
  [self handleDataAfterParse];
  return YES;
}

- (void)setfieldName:(NSString*)name fieldClassName:(NSString*)className value:(id)value{
  NSString* path = [_jsonDataMap safeStringObjectForKey:name];
  if (value == nil) {
      if (NSClassFromString(className) == [NSNumber class]){
          value = @0;
      }else if (NSClassFromString(className) == [NSString class]){
          value = @"";
      }else {
          return;
      }
  }
  //如果结构里嵌套了TBCBaseListItem 也解析
  if ([NSClassFromString(className) isSubclassOfClass:[BaseItem class]]){
    Class entityClass = NSClassFromString(className);
    if (entityClass){
      BaseItem* entityInstance = [[entityClass alloc] init];
      [entityInstance parseData:value];
      [self setValue:entityInstance forKey:name];
    }
  }
  else if (![value isKindOfClass:NSClassFromString(className)]){
    if ([value isKindOfClass:[NSString class]] && NSClassFromString(className) == [NSNumber class]) {
      [self setValue:[NSNumber numberWithInteger:[(NSString *)value integerValue]] forKey:name];
    }else if ([value isKindOfClass:[NSNumber class]] && NSClassFromString(className) == [NSString class]){
      [self setValue:[(NSNumber *)value stringValue] forKey:name];
    }else{
      NSLog(@"json at %@ is dismatch field %@ type",path,name);
    }
    
    return;
  }
  //如果是array判断array内类型
  else if ([NSClassFromString(className) isSubclassOfClass:[NSArray class]]){
    NSString* typeName = [_jsonArrayClassMap safeStringObjectForKey:name];
    if (typeName.length){
      //json中不是array 类型错误
      if (![value isKindOfClass:[NSArray class]]) {
        NSLog(@"json at %@ is not array field %@ type",path,name);
        return;
      }
      Class entityClass = NSClassFromString(typeName);
      //entiyClass不存在
      if (!entityClass){
        NSLog(@"json at %@ class %@ is not exist field %@ type",path,typeName,name);
        return;
      }
      //entiyClass不是TBCJsonEntityBase的子类
      if (![entityClass isSubclassOfClass:[BaseItem class]]){
        NSLog(@"json at %@ class %@ is not subclass of TBCBaseItem field %@ type",path,typeName,name);
        return;
      }
      NSMutableArray* mutableArr = [[NSMutableArray alloc] initWithCapacity:[(NSArray*)value count]];
      for (NSDictionary*dict in (NSArray*)value ){
        //arry中存的不是dict
        if (![dict isKindOfClass:[NSDictionary class]]){
          NSLog(@"json at %@ class dict in Array is dict type field %@ type",path,name);
          return;
        }
        BaseItem* entityInstance =  [[entityClass alloc] init];
        [entityInstance parseData:dict];
        [mutableArr addObject:entityInstance];
      }
      [self setValue:mutableArr forKey:name];
    }
    else{
      [self setValue:value forKey:name];
    }
  }
  //正常情况
  else{
    [self setValue:value forKey:name];
  }
}


-(void)handleDataAfterParse{
  
}

- (void)dealloc {
  _cellHeight = 0;
  _jsonDataMap = nil;
  _jsonArrayClassMap = nil;
}

@end
