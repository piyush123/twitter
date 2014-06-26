//
//  KeychainHandler.h
//  Pods
//
//  Created by piyush shah on 6/26/14.
//
//
//
//  KeychainHandler.h
//
//
//  Created by Mario Kozlovac on 19.10.13.
//  Copyright (c) 2013 meicotilabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainHandler : NSObject

+ (void) storeCredentialsWithUsername:(NSString*)username andPassword:(NSString*)password;
+ (NSDictionary*) getStoredCredentials;

@end