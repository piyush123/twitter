//
//  Tweet.h
//  twitterClient
//
//  Created by piyush shah on 6/24/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MTLModel.h>//MTLModel
#import <MTLJSONAdapter.h>//MTLModel
#import "Mantle/Mantle.h"

@interface Tweet : MTLModel <MTLJSONSerializing>

@property(strong, nonatomic) NSString *text;
@property(strong, nonatomic) NSString *retweeted;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *screenName;
@property(strong, nonatomic) NSString *created;
@property(strong, nonatomic) NSString *profileImageURL;


@end
