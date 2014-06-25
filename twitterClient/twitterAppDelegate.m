//
//  testAppDelegate.m
//  twitterClient
//
//  Created by piyush shah on 6/24/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import "twitterAppDelegate.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "NSURL+QueryString.h"

@implementation twitterAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    self.window.rootViewController = [[LoginViewController alloc] init];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginViewController *vc = [[LoginViewController alloc]init];
    UINavigationController *uvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    uvc.navigationBar.barTintColor =[UIColor colorWithRed:5/255.0f green:6/255.0f blue:206/255.0f alpha:1.0f];
    uvc.navigationBar.alpha = 0.50;
    uvc.navigationBar.translucent = NO;
    
    
    self.window.rootViewController = uvc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"getting into url");
    NSLog(@" url scheme %@", url.scheme);
    
    if ([url.scheme isEqualToString:@"piytweetie"])
    {
        
        NSLog(@" got to url");
        if ([url.host isEqualToString:@"oauth"])
        {
            NSLog(@" got to oauth");
            
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]){
                TwitterClient *client = [TwitterClient instance];
                [client fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                    NSLog(@"access token");
                    [client.requestSerializer saveAccessToken:accessToken];
                    
                    //[client homeTimelineWithSuccess:^ (AFHTTPRequestOperation *operation, id responseObject){
                    //    NSLog(@"response: %@", responseObject);
                    
                    TweetsViewController *tweetsViewController = [[TweetsViewController alloc] init];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
                    navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
                    
                    self.window.rootViewController = navigationController;
                    
                    //} failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    //    NSLog(@"response error: %@", error);
                    //}];
                    
                    
                    
                } failure:^(NSError *error) {
                    NSLog(@"no token");
                }];
            }
        }
        return YES;
    }
    return NO;
}


@end
