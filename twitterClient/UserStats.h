//
//  UserStats.h
//  twitterClient
//
//  Created by piyush shah on 7/2/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MTLModel.h>//MTLModel
#import <MTLJSONAdapter.h>//MTLModel

@interface UserStats : MTLModel<MTLJSONSerializing>

@property(assign, nonatomic) NSString *tweetCount;
@property(assign, nonatomic) NSString *followingCount;
@property(assign, nonatomic) NSString *followersCount;
@property(strong, nonatomic) NSString *profileImageURL;
@property(strong, nonatomic) NSString *backgroundImageURL;
@end
