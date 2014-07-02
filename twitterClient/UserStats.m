//
//  UserStats.m
//  twitterClient
//
//  Created by piyush shah on 7/2/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import "UserStats.h"
#import <MTLJSONAdapter.h>

@implementation UserStats


+ (NSDictionary *) JSONKeyPathsByPropertyKey{
    return @{
             @"tweetCount" : @"user.statuses_count",
             @"followingCount" : @"user.friends_count",
             @"followersCount" : @"user.followers_count",
             @"profileImageURL" : @"user.profile_image_url",
             @"backgroundImageURL" : @"user.profile_background_image_url",
             };
}


@end
