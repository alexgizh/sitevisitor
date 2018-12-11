#import "APIClient.h"
#import "Reachability.h"


@implementation APIClient

+ (APIClient *)sharedClient
{
    static APIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", serverStaticURL]]];
    });
    [_sharedClient.reachabilityManager startMonitoring];
    
    return _sharedClient;
}

- (instancetype) initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];

//    self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
//    self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
//    self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", @"application/x-www-form-urlencoded", nil];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [self.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];

    NSString *authStr = [NSString stringWithFormat:@"wup-sitevisitor:D5Ys#K?Z6fFdosNK(xaC"];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    [self.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];

    [self.requestSerializer setValue:@"Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZDEtdGVjaCIsImV4cCI6NDEwMjM1NDgwMCwianRpIjoiNiJ9.p9H3Va58fYb4cZfbNxJ_Kgbuh73Zrc4dewUsnxmT9uPKOTa_YmC5VOyIDaxQNWQIqto9XwAf4qX7cmXtfSIrog" forHTTPHeaderField:@"JwtAuthorization"];
    
    return self;
}

- (BOOL)connected
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

- (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self setRequestCookie];

    if ([self checkReachability]) {
    
        [self POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(task, responseObject);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error);
//            NSHTTPURLResponse httpResponse = (NSHTTPURLResponse )task.response;
            if (failure) {
                failure(task, error);

            }
        }];
    }else{
        [self showNoInternetConnectionError];
        if (failure)
            failure(nil, nil);
    }
}

- (void)postWithMultipartAndPath:(NSString *)path
              params:(NSDictionary *)params
             success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self setRequestCookie];
    

    [self POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (id key in params) {
            [formData appendPartWithFormData:[[params objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding] name:key];
        }
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"POST MULTIPART path = %@\nparams = %@",path, params);
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(task, error);
        }
    }];
}

- (void)postReturnsStringWithMultipartAndPath:(NSString *)path
                          params:(NSDictionary *)params
                         success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{

    [self POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (id key in params) {
            [formData appendPartWithFormData:[[params objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:key];
        }
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        NSLog(@"POST MULTIPART STRING path = %@\nparams = %@",path, params);
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(task, error);
        }
    }];
}

- (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self setRequestCookie];
    
    if ([self checkReachability]) {
            [self GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"GET path = %@\nparams = %@",path, params);
                if (success) {
                    success(task, responseObject);
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                if (failure) {
                    failure(task, error);
                }
            }];
        }else{
            if (![path isEqualToString:@"account/overview?mobile=1"]){
                [self showNoInternetConnectionError];
                if (failure)
                    failure(nil, nil);
            }
        }
}

- (void)uploadImage:(UIImage *)image
               path:(NSString *)path
             params:(NSDictionary *)params
            success:(void(^)(id responseObject))success
            failure:(void(^)(NSError *error))failure
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
     NSLog(@"Size of Image(bytes):%lu",(unsigned long)[imageData length]);
//    [self setRequestCookie];

    [self POST:path  parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (id key in params)
            [formData appendPartWithFileData:imageData name:key fileName:@"picture.jpg" mimeType:@"image/jpeg"];
    }  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Reply JSON: %@", responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    }];
}

- (void)showErrorAlert:(NSError *)error{
    NSError* errorTemp;
    NSData *data = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];

    if (data) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&errorTemp];
        
        NSLog(@"errorResponse %@", [json objectForKey:@"message"]);
        
        UIAlertController *alert=   [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:[json objectForKey:@"message"]
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action){
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        [alert addAction:okButton];
        
        //[appDelegate.window.inputView presentViewController:alert animated:YES completion:nil];
        
    }else{
        UIAlertController *alert=   [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:@"Please check internet connection and try again"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action){
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        [alert addAction:okButton];
        
        //[appDelegate.window.inputView presentViewController:alert animated:YES completion:nil];
        
    }

}

- (void)showErrorAlertWithString:(NSString *)error{
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController *alert=   [UIAlertController alertControllerWithTitle:@"Error"
                                                                    message:error
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action){
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   topWindow.hidden = YES;

                               }];
    
    [alert addAction:okButton];
    
    
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
//    [appDelegate presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - Reachability

- (BOOL)checkReachability
{
    // we probably have no internet connection, so lets check with Reachability
    Reachability *reachability = [Reachability reachabilityWithHostname:@"http://google.com"];
    
    __block BOOL hasConnection = NO;
    
    if ([reachability isReachable]) {
        // we appear to have a connection, so something else must have gone wrong
         hasConnection = YES;
    }else {
        NSLog(@"Waiting for reachability");
        hasConnection = NO;
        [reachability setReachableBlock:^(Reachability *reachability) {
            if ([reachability isReachable]) {
                NSLog(@"Internet is now reachable");
                [reachability stopNotifier];
                hasConnection = YES;
            }
        }];
        
        [reachability startNotifier];
    }
    
    return hasConnection;
}

- (void)showNoInternetConnectionError{
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [Utils showMessage:@"Please check your internet connection and try again!" withTitle:@""];
//    [delegate showToastWithMessage:@"Please check your internet connection and try again!"];
}

- (void)setRequestCookie{
    
    NSArray *allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *headerFields = [NSHTTPCookie requestHeaderFieldsWithCookies:allCookies];
    for (NSString *key in headerFields) {
//        NSLog(@"%@ %@", key, headerFields[key]);
        [self.requestSerializer setValue:headerFields[key] forHTTPHeaderField:key];
        break;
    }
}

@end
