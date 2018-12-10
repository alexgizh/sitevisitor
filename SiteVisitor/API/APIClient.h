#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AppDelegate.h"

#define serverStaticURL @"https://wup.extranet.netcetera.biz/"

@class FDEvent, FDTemplates;
@interface APIClient : AFHTTPSessionManager<UIAlertViewDelegate>{
        AppDelegate *appDelegate;
}

+ (APIClient *)sharedClient;

- (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)uploadImage:(UIImage *)image
               path:(NSString *)path
             params:(NSDictionary *)params
            success:(void(^)(id responseObject))success
            failure:(void(^)(NSError *error))failure;

- (void)postWithMultipartAndPath:(NSString *)path
                          params:(NSDictionary *)params
                         success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)postReturnsStringWithMultipartAndPath:(NSString *)path
                                       params:(NSDictionary *)params
                                      success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
