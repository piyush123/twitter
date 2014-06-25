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

- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
