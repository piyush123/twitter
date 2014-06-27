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
            TweetsViewController *tweetsViewController =
            [[TweetsViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
            [self presentViewController:navigationController animated:YES completion:nil];
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
