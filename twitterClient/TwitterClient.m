//
//  TwitterClient.m
//  Twitter
//
//  Created by Piyush Shah on 6/22/14.
//  Copyright (c) 2014 Piyush Shah. All rights reserved.
//

#import "TwitterClient.h"


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
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"piytweetie://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got the token");
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get token: %@", error);
    }];
}

- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure{
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
    
}
                                                     

@end
