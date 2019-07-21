//
//  scoketModel.m
//  YSObject
//
//  Created by Long on 2019/2/22.
//  Copyright © 2019 Long. All rights reserved.
//

#import "scoketModel.h"
#import "GCDAsyncSocket.h"
#import "DataModel.h"

@interface scoketModel ()<GCDAsyncSocketDelegate>
@property (nonatomic) uint16_t portNumber;
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) GCDAsyncSocket *serverSocket;
@property (nonatomic, strong) GCDAsyncSocket *acceptedServerSocket;


@property (nonatomic,strong)DataModel * dataModel;
@property (nonatomic,strong)NSArray<NSString *>   * allLocAry;
@property (nonatomic,assign)NSInteger  allLocAryIndex;

@property (nonatomic, retain) NSTimer             *heartTimer;   // 心跳计时器
@property (nonatomic, strong) NSTimer             *grabTime;  //抢单


@end

@implementation scoketModel


// 创建单例
+ (scoketModel *) sharedInstance
{
    static scoketModel *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] initPrivate];
    });
    return sharedInstace;
}

// 私有创建方法，不公开
- (instancetype)initPrivate {
    if (self = [super init]) {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.portNumber = 8097;
        self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        
        self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(longConnectToSocket)
                                                userInfo:nil
                                                 repeats:YES];
        
        self.grabTime = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(grabOrder)
                                                         userInfo:nil
                                                          repeats:YES];
        
        self.allLocAry = [logModel appLocAry];
        self.allLocAryIndex = 0;
        self.carID = @"129";
//        [self whileMethod];
        
    }
    return self;
}

// 废除init创建方法
- (instancetype)init {
    @throw [NSException exceptionWithName:@"初始化异常" reason:@"不允许通过init方法创建对象" userInfo:nil];
}

-(void)connect{
    NSError *error = nil;
    BOOL success = NO;
//    success = [self.serverSocket acceptOnPort:self.portNumber error:&error];
    success = [self.clientSocket connectToHost:@"183.196.249.184" onPort:self.portNumber error:&error];

}

// socket成功连接回调
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"成功连接到%@:%d",host,port);
    [self longConnectToSocket];
    
    [self.heartTimer fire];
    self.currentConnectStatus = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationSocketStatus" object:@(1) userInfo:nil];

}

// 心跳连接
-(void)longConnectToSocket{
//    根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
    NSString *longConnect = myOrderId;
    NSData   *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:dataStream withTimeout:1 tag:1];
}

//发送消息
-(void)writeData:(NSString *)string{
    NSString *longConnect = myOrderId;
    NSData   *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:dataStream withTimeout:1 tag:1];
}

// wirte成功
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    // 持续接收数据
    // 超时设置为附属，表示不会使用超时
//    NSLog(@"wirte 成功");

    [sock readDataWithTimeout:-1 tag:tag];

}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    // 在这里处理消息
    NSString * userInfo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if (userInfo.length>1) {
         NSLog(@"收到消息 \n userInfo : %@ \n--------------------",userInfo);
    }
    
    NSArray * listAry = [userInfo safeArrayFromJsonString];
    
    
    if (listAry.count >= 1) {
        DataModel * dataItem = [[DataModel alloc] initWithData:[listAry safeObjectAtIndex:0]];
        _dataModel = dataItem;
        if ([dataItem.CustomerPhone length] >= 6) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationSocketTick" object:dataItem userInfo:nil];
        }
        NSLog(@"收到消息 \n userInfo : %@ \n--------------------",userInfo);

    }
    //持续接收服务端的数据
    [sock readDataWithTimeout:-1 tag:tag];
}



-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    if (err.code == 57) {
        self.clientSocket.userData = 
        self.clientSocket.userData = @(1); // wifi断开
    }
    else {
        self.clientSocket.userData =  @(2);  // 服务器掉线
    }
    NSLog(@"断开连接，错误：%@",err);
    self.currentConnectStatus = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationSocketStatus" object:@(0) userInfo:nil];
}



-(void)crazyModel{
    [self.grabTime invalidate];
    self.grabTime = nil;
    self.grabTime = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                       target:self
                                                     selector:@selector(grabOrder)
                                                     userInfo:nil
                                                      repeats:YES];
    [self.grabTime fire];
}


-(void)normalModel{
    [self.grabTime invalidate];
    self.grabTime = nil;
    self.grabTime = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                       target:self
                                                     selector:@selector(grabOrder)
                                                     userInfo:nil
                                                      repeats:YES];
    [self.grabTime fire];
}



-(void)grabOrder{
    
    return;
    if (![_dataModel.Status boolValue] ) {
        NSInteger selIndex = arc4random() % 11;
        

        CocoaSecurityResult * md5StrAll129 = [CocoaSecurity md5:[NSString stringWithFormat:@"%@%@%@",_dataModel.bid,_carID,myAppKey]];

        NSString * MD5all129 = md5StrAll129.hex;
//        NSString * urlAPIall129c = orderUrlAll((long)[_dataModel.bid integerValue], [_allLocAry safeStringObjectAtIndex:selIndex], MD5all129);
        NSString * urlAPIall129c = carOrderUrlAll((long)[_dataModel.bid integerValue],_carID, [_allLocAry safeStringObjectAtIndex:selIndex], MD5all129);
        NSLog(@"*****%@",urlAPIall129c);
//        CocoaSecurityResult * md5StrAll129_1 = [CocoaSecurity md5:[NSString stringWithFormat:@"%ld%@%@",[_dataModel.bid integerValue] + 1,_carID,myAppKey]];
//        NSString * MD5all129_1 = md5StrAll129_1.hex;
//        NSString * urlAPIall129c_1 = orderUrlAll([_dataModel.bid integerValue]+1, [_allLocAry safeStringObjectAtIndex:selIndex], MD5all129_1);
//        NSLog(@"---  ab -n 8000 -c 200 %@",urlAPIall129c_1);
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

        dispatch_apply(20, queue, ^(size_t index) {
            [[NetworkManager shareInstance] functionAPI:urlAPIall129c params:@{} Method:@"GET" completeHandle:^(NSDictionary * _Nonnull resultDic) {
//                NSLog(@"%@",resultDic);
            } errorHandler:^(NSError * _Nonnull error, NSDictionary * _Nullable resultDic) {
                if ([resultDic[@"Result"] count]) {
                    NSLog(@"%@\n-----------------------\n129",resultDic);
                }
            }];
        });
    }
}



-(void)whileMethod{

    while (YES) {
        if (!self->_dataModel.bid) {
            continue;
        }
        
        dispatch_queue_t grabQue = dispatch_queue_create("com.order.gcd.com", DISPATCH_QUEUE_CONCURRENT);
        
        dispatch_async(grabQue, ^{
           
            if (self->_allLocAryIndex == self->_allLocAry.count-1) {
                self->_allLocAryIndex = 0;
            }
            CocoaSecurityResult * md5StrAll129 = [CocoaSecurity md5:[NSString stringWithFormat:@"%@129%@",self->_dataModel.bid,myAppKey]];
            NSString * MD5all129 = md5StrAll129.hex;
            NSString * urlAPIall129 = orderUrlAll([self->_dataModel.bid integerValue], [self->_allLocAry safeStringObjectAtIndex:self->_allLocAryIndex], MD5all129);
            NSString * urlAPIall129a = orderUrlAll([self->_dataModel.bid integerValue], [self->_allLocAry safeStringObjectAtIndex:self->_allLocAryIndex+ 15], MD5all129);
            NSString * urlAPIall129b = orderUrlAll([self->_dataModel.bid integerValue], [self->_allLocAry safeStringObjectAtIndex:self->_allLocAryIndex+30], MD5all129);
            self->_allLocAryIndex++;
            NSLog(@"请求地址%@",urlAPIall129);
            [[NetworkManager shareInstance] functionAPI:urlAPIall129 params:@{} Method:@"GET" completeHandle:^(NSDictionary * _Nonnull resultDic) {
                NSLog(@"%@",resultDic);
            } errorHandler:^(NSError * _Nonnull error, NSDictionary * _Nullable resultDic) {
                if ([resultDic[@"Result"] count]) {
                    NSLog(@"%@\n-----------------------\n129",resultDic);
                }
            }];
            
            [[NetworkManager shareInstance] functionAPI:urlAPIall129a params:@{} Method:@"GET" completeHandle:^(NSDictionary * _Nonnull resultDic) {
                NSLog(@"%@",resultDic);
            } errorHandler:^(NSError * _Nonnull error, NSDictionary * _Nullable resultDic) {
                if ([resultDic[@"Result"] count]) {
                    NSLog(@"%@\n-----------------------\n129",resultDic);
                }
            }];
            
            [[NetworkManager shareInstance] functionAPI:urlAPIall129b params:@{} Method:@"GET" completeHandle:^(NSDictionary * _Nonnull resultDic) {
                NSLog(@"%@",resultDic);
            } errorHandler:^(NSError * _Nonnull error, NSDictionary * _Nullable resultDic) {
                if ([resultDic[@"Result"] count]) {
                    NSLog(@"%@\n-----------------------\n129",resultDic);
                }
            }];
        });
    }
}


@end
