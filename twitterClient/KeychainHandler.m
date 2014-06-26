//
//  KeychainHandler.m
//
//
//  Created by Mario Kozlovac on 19.10.13.
//  Copyright (c) 2013 meicotilabs. All rights reserved.
//

#import "KeychainHandler.h"
#import "KeychainItemWrapper.h"

@implementation KeychainHandler

+ (void) storeCredentialsWithUsername:(NSString*)username andPassword:(NSString*)password{
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:[[NSBundle mainBundle] bundleIdentifier] accessGroup:nil];
    
    [keychainItem resetKeychainItem];
    
    [keychainItem setObject:username forKey:(__bridge id)(kSecAttrAccount)];
    [keychainItem setObject:password forKey:(__bridge id)(kSecValueData)];
    
}

+ (NSDictionary*) getStoredCredentials{
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:[[NSBundle mainBundle] bundleIdentifier] accessGroup:nil];
    
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                username,
                                                password,
                                                nil]
                                       forKeys:[NSArray arrayWithObjects:
                                                [NSString stringWithFormat:@"Username"],
                                                [NSString stringWithFormat:@"Password"],
                                                nil]];
    
}

@end