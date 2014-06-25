//
//  NSURL+QueryString.h
//  twitterClient
//
//  Created by piyush shah on 6/24/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (QueryString)

- (NSDictionary *)dictionaryFromQueryString;

@end
