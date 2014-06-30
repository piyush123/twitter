//
//  LoginViewController.m
//  twitterClient
//
//  Created by piyush shah on 6/24/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "TweetsViewController.h"


#import "containerViewController.h"
#import "menuViewController.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *twitterLogin;
@property (strong, nonatomic) IBOutlet UIView *LoginTableView;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([User currentUser] != nil) {
        NSLog(@"current user %@", User.currentUser);
        [User checkCurrentUser:^{
            
            TweetsViewController *tweets_vc = [[TweetsViewController alloc] initWithAPI:@""];
            
            TweetsViewController *mentions_vc = [[TweetsViewController alloc] init];
            
            menuViewController  *menu_vc = [[menuViewController alloc] init];
            containerViewController  *container_vc = [[containerViewController alloc] init];
            
            [container_vc addViewController:menu_vc];
            [container_vc addViewController:mentions_vc];
            [container_vc addViewController:tweets_vc];

            
            UINavigationController *uvc = [[UINavigationController alloc] initWithRootViewController:container_vc];
            
            uvc.navigationBar.barTintColor =[UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
            uvc.navigationBar.alpha = 0.50;
            uvc.navigationBar.translucent = NO;
           
            
            //55acee
            //
            [self presentViewController:uvc animated:YES completion:nil];
        } :^(NSError *error) {
            NSLog(@"don't have user token");
            [[TwitterClient instance] login];
        }];
    }

}

- (IBAction)twitterLogin:(id)sender
{
    [[TwitterClient instance] login];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
