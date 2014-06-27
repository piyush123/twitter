//
//  Utils.m
//  twitterClient
//
//  Created by piyush shah on 6/26/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import "Utils.h"
#import <UIImageView+AFNetworking.h>

@implementation Utils

+ (void)setImageWithUrl:(NSString *)url inImageView:(UIImageView *)imageView

{
    [imageView
     setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
     placeholderImage:nil
     success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
         imageView.image = image;
         NSLog(@"Loaded successfully: %ld", (long)[response statusCode]);
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
         NSLog(@"failed loading: %@", error);
     }
     ];
}
@end
