//
//  WSNetworking.m
//  WSNetworking
//
//  Created by 魏山 on 2018/4/28.
//  Copyright © 2018年 yyhj. All rights reserved.
//

#import "WSNetworking.h"
#import <AFNetworking.h>

#define WS(self)  __weak __typeof(&*self)self = self

@interface WSNetworking()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableArray *requestTasks;

@end

@implementation WSNetworking
+ (instancetype)sharedInstance
{
    static WSNetworking *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 30;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        manager.operationQueue.maxConcurrentOperationCount = 3;
        sharedInstance.manager = manager;
        sharedInstance.requestTasks = [NSMutableArray array];
    });
    return sharedInstance;
}

+ (NSURLSessionDataTask *)requestWithRequestType:(WSRequestType)requestType
                                             url:(NSString *)url
                                          params:(NSDictionary *)params
                                         success:(void (^)(id))success
                                         failure:(void (^)(NSError *))failure
{
    return [self requestWithRequestType:requestType url:url params:params success:success failure:failure];
}

- (NSURLSessionDataTask *)requestWithRequestType:(WSRequestType)requestType
                                             url:(NSString *)url
                                          params:(NSDictionary *)params
                                         success:(void (^)(id))success
                                         failure:(void (^)(NSError *))failure
{
    __block NSURLSessionDataTask *task = nil;
    AFHTTPSessionManager *manager = [[WSNetworking sharedInstance] manager];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        switch (requestType) {
                
            case WSRequestTypeGet:{
                
                task = [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [self responseSuccess:success object:responseObject task:task];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [self responseFailure:failure error:error task:task];
                }];
                break;
            }
                
            case WSRequestTypePost:{
                
                task = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [self responseSuccess:success object:responseObject task:task];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [self responseFailure:failure error:error task:task];
                }];
                break;
            }
                
            case WSRequestTypePatch:{
                
                task = [manager PATCH:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [self responseSuccess:success object:responseObject task:task];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [self responseFailure:failure error:error task:task];
                }];
                break;
            }
                
            case WSRequestTypeDelete:{
                
                task = [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [self responseSuccess:success object:responseObject task:task];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [self responseFailure:failure error:error task:task];
                }];
                break;
            }
                
            case WSRequestTypePut:{
                
                task = [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [self responseSuccess:success object:responseObject task:task];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [self responseFailure:failure error:error task:task];
                }];
                break;
            }
        }
    });
    
    [self.requestTasks addObject:task];
    return task;
}

- (NSURLSessionDataTask *)uploadImagesWithUrl:(NSString *)url
                                     fileName:(NSString *)fileName
                                       params:(NSDictionary *)params
                                   imageArray:(NSArray *)imageArray
                                     progress:(WSProgress)progress
                                      success:(void (^)(id))success
                                      failure:(void (^)(NSError *))failure
{
    __block NSURLSessionDataTask *task = nil;
    AFHTTPSessionManager *manager = [[WSNetworking sharedInstance] manager];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
            
            for (int i = 0; i < imageArray.count; i ++) {
                
                NSData *data = UIImageJPEGRepresentation(imageArray[i], 0.8); 
                NSString *formatFileName = [NSString stringWithFormat:@"%@.jpg",[self getCurrentTime]];
                
                [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"%@%d",fileName,i] fileName:formatFileName mimeType:@"image/jpeg"];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            [self responseProgress:progress uploadProgress:uploadProgress];
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            
            [self responseSuccess:success object:responseObject task:task];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            
            [self responseFailure:failure error:error task:task];
        }];
        
    });
    
    [self.requestTasks addObject:task];
    return task;
}

- (NSURLSessionDataTask *)uploadFileWithUrl:(NSString *)url
                                     params:(NSDictionary *)params
                                 uploadPath:(NSString *)uploadPath
                                   progress:(WSProgress)progress
                                    success:(void (^)(id))success
                                    failure:(void (^)(NSError *))failure
{
    __block NSURLSessionDataTask *task = nil;
    AFHTTPSessionManager *manager = [[WSNetworking sharedInstance] manager];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLRequest *uploadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [manager uploadTaskWithRequest:uploadRequest fromFile:[NSURL URLWithString:uploadPath] progress:^(NSProgress * _Nonnull uploadProgress) {
            [self responseProgress:progress uploadProgress:uploadProgress];
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error == nil) {
                [self responseSuccess:success object:responseObject task:task];
            }else{
                [self responseFailure:failure error:error task:task];
            }
        }];
        
    });
    
    [self.requestTasks addObject:task];
    return task;

    
}

- (NSURLSessionDataTask *)downloadFileWithUrl:(NSString *)url
                                       params:(NSDictionary *)params
                                   saveToPath:(NSString *)saveToPath
                                     progress:(WSProgress)progress
                                      success:(void (^)(id))success
                                      failure:(void (^)(NSError *))failure
{
    __block NSURLSessionDataTask *task = nil;
    AFHTTPSessionManager *manager = [[WSNetworking sharedInstance] manager];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
            [self responseProgress:progress uploadProgress:downloadProgress];
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:saveToPath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error == nil) {
                
                [self responseSuccess:success object:filePath.absoluteString task:task];
            }else{
                [self responseFailure:failure error:error task:task];
            }
        }];
        
    });
    
    [self.requestTasks addObject:task];
    return task;

    
}

- (void)responseSuccess:(void (^)(id responseObject))success object:(id)object task:(NSURLSessionDataTask *)task{
    
    [self.requestTasks removeObject:task];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (success){
            
            success(object);
        }
    });
}

- (void)responseProgress:(WSProgress)progress uploadProgress:(NSProgress *)uploadProgress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (progress){
            
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    });

    
}

- (void)responseFailure:(void(^)(NSError *failure))failure error:(NSError *)error task:(NSURLSessionDataTask *)task{
    
    [self.requestTasks removeObject:task];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (failure){

            failure(error);
        }
    });
}

- (void)cancelAllRequest {
    @synchronized(self) {
        [self.requestTasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
                [task cancel];
            }
        }];
        
        [self.requestTasks removeAllObjects];
    };
}

- (void)cancelRequestWithURL:(NSString *)url {
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        [self.requestTasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[NSURLSessionDataTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [self.requestTasks removeObject:task];
                return;
            }
        }];
    };
}

- (NSString *)getFailureMessageWithError:(NSError *)error
{
    NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    if (errorData == nil) {
        return @"网络错误,请稍后再试!";
    }
    NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableContainers error:nil];
    NSString *message = [errorDict objectForKey:@"message"];
    return message;
}

- (NSUInteger)getFailureStatusWithError:(NSError *)error
{
    NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    if (errorData == nil) {
        return 404;
    }
    NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableContainers error:nil];
    NSUInteger status = [[errorDict objectForKey:@"status"] integerValue];
    return status;
}

- (NSString *)getCurrentTime
{
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"yyyyMMddHHmmss";
    NSString *str1 = [formatter1 stringFromDate:[NSDate date]];
    return str1;
}
@end
