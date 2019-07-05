//
//  NetworkManager.m
//  YSObject
//
//  Created by Long on 2019/2/22.
//  Copyright © 2019 Long. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>

@interface NetworkManager()
@property(nonatomic, strong)AFHTTPSessionManager *manager;
@end

@implementation NetworkManager

static NetworkManager * _instance;
+ (NetworkManager *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NetworkManager alloc] init];
    });
    
    return _instance;
}

- (id)init{
    if (self = [super init]) {
//        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
         _manager = [[AFHTTPSessionManager alloc] init];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                   @"text/html",
                                                                                   @"text/json",
                                                                                   @"text/plain",
                                                                                   @"text/javascript",
                                                                                   @"text/xml",
                                                                                   @"image/*"]];
        [_manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"User-Agent"];
        
    }
    return self;
}



- (void)functionAPI:(NSString     *)api
             params:(NSDictionary *)params
             Method:(NSString*)method
     completeHandle:(NetworkManagerDicBlock)completionHandler
       errorHandler:(NetworkManagerErrorBlock)errorHandler{
    [self functionAPI:api params:params data:nil dataKey:nil Method:method completeHandle:completionHandler errorHandler:errorHandler];
}


- (void)functionAPI:(NSString     *)api
             params:(NSDictionary *)params
               data:(NSData       *)data
            dataKey:(NSString     *)dataKey
             Method:(NSString*)method
     completeHandle:(NetworkManagerDicBlock)completionHandler
       errorHandler:(NetworkManagerErrorBlock)errorHandler{
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionary];
    if (params) {
        [mutableParams addEntriesFromDictionary:params];
    }
    
    if (data && dataKey) {
        NSMutableURLRequest *request =
        [[AFHTTPRequestSerializer serializer]
         multipartFormRequestWithMethod:@"POST"
         URLString:[ALServerHost stringByAppendingString:api]
         parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
             [formData appendPartWithFileData:data
                                         name:dataKey
                                     fileName:dataKey
                                     mimeType:@"image/jpeg"];
         } error:nil];
        
        NSURLSessionUploadTask *uploadTask =
        [_manager
         uploadTaskWithStreamedRequest:request
         progress:^(NSProgress * _Nonnull uploadProgress) {
         }
         completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
             CommonItem *item = (CommonItem *)[[CommonItem alloc] initWithData:responseObject];
             int errorNum = [item.error.errorno intValue];
             if (errorNum == 200) {
                 dispatch_async(dispatch_get_main_queue(),^{
                     if (completionHandler) {
                         completionHandler(responseObject);
                     }
                 });
             }else{
                 dispatch_async(dispatch_get_main_queue(),^{
                     NSString *tip = item.error.usermsg;
                     if(tip&&tip.length>0){
                         [PDProgressHUD showTip:tip];
                     }
                 });
                 NSError *error = nil;
                 if (errorHandler) {
                     errorHandler(error, responseObject);
                 }
             }
         }];
        
        [uploadTask resume];
    }else{
        if ([self isRSARequest:api]) {
            NSMutableURLRequest * request;
            [AFHTTPRequestSerializer serializer].timeoutInterval = 10;
            
            if ([method isEqualToString:@"GET"]) {
                request =
                [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                              URLString:[ALServerHost stringByAppendingString:api]
                                                             parameters:mutableParams
                                                                  error:nil];
            }else{
                request =
                [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST"
                                                              URLString:[ALServerHost stringByAppendingString:api] //[NSString stringWithFormat:@"/v1%@",
                                                             parameters:mutableParams
                                                                  error:nil];
            }
            if (ALNetRequestType) {
//                NSData *encData =  [RSA encryptData:request.HTTPBody publicKey:_publicRSAKey];
//                encData = [encData base64EncodedDataWithOptions:0];
//                request.HTTPBody = encData;
            }
            
            //      NSString *urlString = [NSString stringWithFormat:@"%@/v1%@?format=rsa",ALServerHost,api];
            //      request.URL = [NSURL URLWithString:urlString];
            __weak typeof(self)wSelf = self;
            NSURLSessionDataTask *dataTask =
            [_manager dataTaskWithRequest:request
                           uploadProgress:nil
                         downloadProgress:nil
                        completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                            
                            if (ALNetRequestType) {
//                                NSString *encryptedString = [responseObject safeStringObjectForKey:@"response"];
//                                if (encryptedString.length) {
//                                    NSData *encData = [[NSData alloc] initWithBase64EncodedString:encryptedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
//                                    NSData *decryptData = [encData RSADecryptDataWithPrivateKey:wSelf.privateSecurityKey];
//                                    NSString *decryptedString = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
//                                    NSDictionary *resultDic = [decryptedString safeJsonDicFromJsonString];
//                                    [wSelf dealWithResultDic:resultDic
//                                                         api:api
//                                              completeHandle:completionHandler
//                                                errorHandler:errorHandler];
//                                }else{
//                                    if (errorHandler) {
//                                        errorHandler(error,nil);
//                                    }
//                                }
                            }else{
                                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                    [wSelf dealWithResultDic:responseObject
                                                         api:api
                                              completeHandle:completionHandler
                                                errorHandler:errorHandler];
                                }else{
                                    if (errorHandler) {
                                        errorHandler(error,nil);
                                    }
                                }
                            }
                        }];
            [dataTask resume];
        }else{
            __weak typeof(self)wSelf = self;
            if ([method isEqualToString:@"GET"]) {
                
                [_manager GET:api
                   parameters:mutableParams
                     progress:^(NSProgress * _Nonnull downloadProgress) {
                     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         [wSelf dealWithResultDic:responseObject
                                              api:api
                                   completeHandle:completionHandler
                                     errorHandler:errorHandler];
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if (errorHandler) {
                             errorHandler(error, nil);
                         }
                     }];
            }else{
                [_manager POST:api
                    parameters:mutableParams
                      progress:nil
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           [wSelf dealWithResultDic:responseObject
                                                api:api
                                     completeHandle:completionHandler
                                       errorHandler:errorHandler];
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           if (errorHandler) {
                               errorHandler(error, nil);
                           }
                       }];
            }
        }
    }
}




- (void)dealWithResultDic:(NSDictionary *)resultDic
                      api:(NSString *)api
           completeHandle:(NetworkManagerDicBlock)completionHandler
             errorHandler:(NetworkManagerErrorBlock)errorHandler{
    CommonItem *item = (CommonItem *)[[CommonItem alloc] initWithData:resultDic];
    int errorNum = [item.error.errorno intValue];
    
    if (errorNum == 200) {
        //    dispatch_async(dispatch_get_main_queue(),^{
        //      if (completionHandler) {
        //        completionHandler(resultDic);
        //      }
        //    });
        if (completionHandler) {
            completionHandler(resultDic);
        }
    }else if(errorNum == 100004) {

    }else if(errorNum == 100005) {
      
    }else{
        NSError *error = nil;
        if (errorHandler) {
            errorHandler(error, resultDic);
        }
    }
}

- (NSString *)hostName{
    return ALServerHost;
}



- (BOOL)isRSARequest:(NSString *)api{
    return false;
}

-(void)testNetwork{
    
//    NSURLSessionConfiguration * sessionConfiguta = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager * urlSession = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguta];
//
//    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"www.aa.com"]];
//
//    NSURLSessionDownloadTask * dask = [urlSession downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"%f",downloadProgress.fractionCompleted);
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        NSURL * urlFile = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
//        return [urlFile URLByAppendingPathComponent:[response suggestedFilename]];
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        NSLog(@"filePath = %@ \nError = %@",filePath,error.userInfo);
//    }];
//    [dask resume];
    
    
//    
//    NSMutableURLRequest * mutableRequest = [[AFHTTPRequestSerializer  serializer] multipartFormRequestWithMethod:@"post"
//                                                                                                       URLString:@"www.aa.com"
//                                                                                                      parameters:nil
//                                                                                       constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//                                                                                           <#code#>
//                                                                                       } error:nil];
//    AFURLSessionManager * manage = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSURLSessionUploadTask * uploadTask;
//    uploadTask = [manage uploadTaskWithStreamedRequest:mutableRequest
//                                              progress:^(NSProgress * _Nonnull uploadProgress) {
//                                                  <#code#>
//                                              } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                                                  <#code#>
//                                              }];
    
}
@end
