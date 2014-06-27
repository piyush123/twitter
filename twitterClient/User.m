//
//  User.m
//  twitterClient
//
//  Created by piyush shah on 6/24/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"


@implementation User

static User *currentUser = nil;
static NSString *storeKey = @"current_user";


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"profile_image_url": @"profile_image_url",
             @"screenName": @"screen_name"
             };
}


+ (NSArray *)usersWithArray:(NSArray *)array {
    NSMutableArray *Users = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array) {
        User *usr = [[User alloc] initWithDictionary:dictionary];
        [Users addObject:usr];
    }
    
    return Users;    
}

+ (User *)currentUser {
    if (currentUser == nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *archivedObject = [defaults objectForKey:storeKey];
        currentUser = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedObject];
    }
    return currentUser;
}

+ (void)setCurrentUser:(User *)user {
    currentUser = user;
    NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:archivedObject forKey:storeKey];
    [defaults synchronize];
}

// Check if User auth in

+ (void)checkCurrentUser:(void (^) ())success
                             :(void (^) (NSError *error))failure {
    TwitterClient *client = [TwitterClient instance];
    [client verifyCredentials:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"check User success");
        User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject error:nil];
        [User setCurrentUser:user];
        if (success) {
            success();
        }
    } :^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"check user failure: %@", error.description);
        if (failure) {
            failure(error);
        }
    }];
}

@end

