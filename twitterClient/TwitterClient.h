//
//  TwitterClient.h
//  Twitter
//
//  Created by Piyush Shah on 6/22/14.
//  Copyright (c) 2014 Piyush Shah. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"


@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) instance;

- (void) login;

- (AFHTTPRequestOperation *)homeTimeline:(void (^)(AFHTTPRequestOperation *operation, id response))success :(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)mentionsTimeline:(void (^)(AFHTTPRequestOperation *operation, id response))success :(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



- (AFHTTPRequestOperation *)verifyCredentials:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                                :(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;


- (void)finishLoginWith:(NSString *)queryString withCompletion:(void (^) ())completion;


- (AFHTTPRequestOperation *)updateStatus:(NSString *)status
                                        :(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                        :(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;


@end
