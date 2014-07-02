//
//  TwitterClient.m
//  Twitter
//
//  Created by Piyush Shah on 6/22/14.
//  Copyright (c) 2014 Piyush Shah. All rights reserved.
//
//
//
//BDBOAuth1RequestSerializer also has built-in support for storing and retrieving access tokens to/from the user's keychain, utilizing the service name to differentiate tokens. BDBOAuth1RequestOperationManger and BDBOAuth1SessionManager automatically set the service name to baseURL.host (e.g. api.twitter.com) when they are instantiated.

#import "TwitterClient.h"
#import "User.h"

@implementation TwitterClient

+ (TwitterClient *) instance {
    
    static TwitterClient *instance = nil;
    static dispatch_once_t pred;
   
    dispatch_once(&pred, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"1MJQVSZTPBigxZj6WUr8OhKEP" consumerSecret:@"zZ2MefzDGvR62rfbBLv0Ye4PqRrdgbfOmx110vNB1LFfwcbaHj"] ;
    });
    
    return instance;
}

- (void)login{
   
    [self.requestSerializer removeAccessToken]; 
    [self fetchRequestTokenWithPath:@"oauth/request_token"
                             method:@"POST"
                        callbackURL:[NSURL URLWithString:@"piytweetie://oauth"]
                              scope:nil
                            success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got the token");
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get token: %@", error);
    }];
}



- (void)finishLoginWith:(NSString *)queryString withCompletion:(void (^) ())completion {
    NSLog(@"in finish login");
    [self fetchAccessTokenWithPath:@"/oauth/access_token"
                            method:@"POST"
                      requestToken:[BDBOAuthToken tokenWithQueryString:queryString]
                           success:^(BDBOAuthToken *accessToken) {
                               NSLog(@"[TwitterClient finishLogin] success");
                               [self.requestSerializer saveAccessToken:accessToken];
                               [User checkCurrentUser:^{
                                   if (completion) {
                                       NSLog(@"completion block");
                                       completion();
                                   }
                               } :^(NSError *error) {
                                   NSLog(@"[TwitterClient finishLogin] verify failure: %@", error.description);
                               }];
                               
                           } failure:^(NSError *error) {
                               NSLog(@"[TwitterClient finishLogin] failure: %@", error.description);
                           }];
}

- (AFHTTPRequestOperation *)userTimeLine:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure{
    return [self GET:@"1.1/statuses/user_timeline.json" parameters:nil success:success failure:failure];
    
}

- (AFHTTPRequestOperation *)userProfile:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *parameters = @{@"screen_name": parameter}; //, @"location" : @"San Francisco"};
    return [self GET:@"1.1/statuses/user_timeline.json" parameters:parameters success:success failure:failure];
    
}

- (AFHTTPRequestOperation *)homeTimeline:(void (^) (AFHTTPRequestOperation *operation, id responseObject))
                                success :(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
    
    // return [self GET:@"1.1/statuses/mentions_timeline.json" parameters:nil success:success failure:failure];
   
   // 1.1/statuses/mentions_timeline.json
}

- (AFHTTPRequestOperation *)mentionsTimeline:(void (^) (AFHTTPRequestOperation *operation,  id responseObject))
                                success :(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
 //   return [self GET:@"asdf" parameters:nil success:success failure:failure];
    
    return [self GET:@"1.1/statuses/mentions_timeline.json" parameters:nil success:success failure:failure];
    
    // 1.1/statuses/mentions_timeline.json
}


- (AFHTTPRequestOperation *)verifyCredentials:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure{
    
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
    
}



- (AFHTTPRequestOperation *)updateStatus:(NSString *)status
                                     :(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                     :(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"status": status};
    return [self POST:@"1.1/statuses/update.json" parameters:parameters success:success failure:failure];
}
                                                     

@end
