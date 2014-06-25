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

@interface Tweet : MTLModel <MTLJSONSerializing>

@property (nonatomic,strong) NSString  *text;
@property (nonatomic,strong) NSString  *time;
@property (nonatomic,strong) NSString *profile_image_url;
@property (nonatomic,strong) NSString *description;

@property (nonatomic,strong) NSString *retweeted;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) NSString *screenname;

@property (nonatomic,strong) NSString *name;

@end
