//
//  User.h
//  twitterClient
//
//  Created by piyush shah on 6/24/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MTLModel.h>//MTLModel
#import <MTLJSONAdapter.h>//MTLModel

@interface User : MTLModel <MTLJSONSerializing>

@property (nonatomic,strong) NSString  *name;
@property (nonatomic,strong) NSString *profile_image_url;
@property (nonatomic, strong) NSString *screenName;

+ (User *)currentUser;

+ (void)setCurrentUser:(User *)user;
+ (void)checkCurrentUser:(void (^) ())success
                             :(void (^) (NSError *error))failure;


@end
