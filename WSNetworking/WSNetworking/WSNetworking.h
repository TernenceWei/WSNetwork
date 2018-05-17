//
//  WSNetworking.h
//  WSNetworking
//
//  Created by 魏山 on 2018/4/28.
//  Copyright © 2018年 yyhj. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 所有的网络请求都会新开子线程，成功，失败及进度回调都在主线程

 */
typedef NS_ENUM(NSUInteger, WSRequestType) {
    WSRequestTypeGet         = 1, // get请求
    WSRequestTypePost        = 2, // post请求
    WSRequestTypePatch       = 3, // patch请求
    WSRequestTypePut         = 4, // put请求
    WSRequestTypeDelete      = 5, // delete请求
};

typedef NS_ENUM(NSUInteger, WSResponseType) {
    WSResponseTypeSuccess     = 1, // 请求成功
    WSResponseTypeNoData      = 2, // 无数据
    WSResponseTypeNoMoreData  = 3, // 无更多数据
    WSResponseTypeNoNetwork   = 4, // 无网络
    WSResponseTypeServerError = 5, // 服务器错误
};

typedef NS_ENUM(NSInteger, WSNetworkStatus) {
    WSNetworkStatusUnknown          = -1,//未知网络
    WSNetworkStatusNotReachable     = 0, //网络无连接
    WSNetworkStatusReachableViaWWAN = 1, //2，3，4G网络
    WSNetworkStatusReachableViaWiFi = 2, //WIFI网络
};

typedef void (^WSProgress)(int64_t completedUnitCount, int64_t totalUnitCount);
typedef void(^WSResponseSuccess)(id responseObject);
typedef void(^WSResponseFailure)(NSError *error);

typedef void (^OperationBlock)(WSResponseType responseType, BOOL result, NSString *message);
typedef void (^DataBlock)(WSResponseType responseType, id data, NSString *message);
typedef void (^DataCountBlock)(WSResponseType responseType, id data, NSUInteger count, NSString *message);
typedef void (^StatusBlock)(WSResponseType responseType, NSInteger status, NSString *message);

@interface WSNetworking : NSObject

+ (instancetype)sharedInstance;
/**
 发起网络请求

 @param requestType 请求方式
 @param url url
 @param params 参数
 @param success 成功回调
 @param failure 失败回调
 @return NSURLSessionDataTask
 */
- (NSURLSessionTask *)requestWithRequestType:(WSRequestType)requestType
                                         url:(NSString *)url
                                      params:(NSDictionary *)params
                                     success:(WSResponseSuccess)success
                                     failure:(WSResponseFailure)failure;


/**
 上传图片

 @param url url
 @param fileName 文件名称
 @param params 参数
 @param imageArray 图片数组，<UIImage*>
 @param progress 进度条
 @param success 成功回调
 @param failure 失败回调
 @return NSURLSessionDataTask
 */
- (NSURLSessionTask *)uploadImagesWithUrl:(NSString *)url
                                 fileName:(NSString *)fileName
                                   params:(NSDictionary *)params
                               imageArray:(NSArray *)imageArray
                                 progress:(WSProgress)progress
                                  success:(WSResponseSuccess)success
                                  failure:(WSResponseFailure)failure;


/**
 上传文件

 @param url url
 @param params 参数
 @param uploadPath 待上传文件路径
 @param progress 上传进度
 @param success 成功回调
 @param failure 失败回调
 @return NSURLSessionDataTask
 */
- (NSURLSessionTask *)uploadFileWithUrl:(NSString *)url
                                 params:(NSDictionary *)params
                             uploadPath:(NSString *)uploadPath
                               progress:(WSProgress)progress
                                success:(WSResponseSuccess)success
                                failure:(WSResponseFailure)failure;


/**
 下载文件，支持断点续传

 @param url url
 @param params 参数
 @param saveToPath 保存在沙盒的路径
 @param progress 进度条
 @param success 成功回调
 @param failure 失败回调
 @return NSURLSessionDataTask
 */
- (NSURLSessionTask *)downloadFileWithUrl:(NSString *)url
                                   params:(NSDictionary *)params
                               saveToPath:(NSString *)saveToPath
                                 progress:(WSProgress)progress
                                  success:(WSResponseSuccess)success
                                  failure:(WSResponseFailure)failure;
/**
 *    取消所有请求
 */
- (void)cancelAllRequest;

/**
 *    取消某个请求
 *    @param url  URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
- (void)cancelRequestWithURL:(NSString *)url;

@end
