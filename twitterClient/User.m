//
//  User.m
//  twitterClient
//
//  Created by piyush shah on 6/24/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import "User.h"


@implementation User


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name":@"name",
             @"address":@"location.display_address"
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


@end

