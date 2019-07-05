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


@property (nonatomic, retain) NSTimer             *heartTimer;   // 心跳计时器

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
        
        
        self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:0.8
                                                  target:self
                                                selector:@selector(longConnectToSocket)
                                                userInfo:nil
                                                 repeats:YES];
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
    NSLog(@"wirte 成功");

    [sock readDataWithTimeout:-1 tag:tag];

}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    // 在这里处理消息
    NSString * userInfo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   
    
    NSArray * listAry = [userInfo safeArrayFromJsonString];
    
    if (listAry.count >= 1) {
        DataModel * dataItem = [[DataModel alloc] initWithData:[listAry safeObjectAtIndex:0]];
        if ([dataItem.CustomerPhone length] >= 6) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationSocketTick" object:dataItem userInfo:nil];
        }
        
        if (userInfo && userInfo.length>10) {
            NSLog(@"收到消息 \n userInfo : %@ \n--------------------",userInfo);
            if (![dataItem.Status boolValue]) {
                CocoaSecurityResult * md5Str = [CocoaSecurity md5:[NSString stringWithFormat:@"%@129%@",dataItem.bid,myAppKey]];
                NSString * MD5Str = md5Str.hex;
                
                NSString * urlAPI = orderUrl(dataItem.bid, MD5Str);
          
                dispatch_queue_t queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
                dispatch_apply(1000,queue, ^(size_t index) {
                    NSLog(@"当前执行次数-%ld次",index);
                    [[NetworkManager shareInstance] functionAPI:urlAPI params:@{} Method:@"GET" completeHandle:^(NSDictionary * _Nonnull resultDic) {
                        NSLog(@"%@",resultDic);
                    } errorHandler:^(NSError * _Nonnull error, NSDictionary * _Nullable resultDic) {
                        NSLog(@"%@",resultDic);
                    }];
                });
            }
        }
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
    [self.heartTimer invalidate];
    self.heartTimer = nil;
    self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                       target:self
                                                     selector:@selector(longConnectToSocket)
                                                     userInfo:nil
                                                      repeats:YES];
    [self.heartTimer fire];
}


-(void)normalModel{
    [self.heartTimer invalidate];
    self.heartTimer = nil;
    self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:0.6
                                                       target:self
                                                     selector:@selector(longConnectToSocket)
                                                     userInfo:nil
                                                      repeats:YES];
    [self.heartTimer fire];
}

@end
