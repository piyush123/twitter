//
//  menuViewController.m
//  twitterClient
//
//  Created by piyush shah on 6/29/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import "menuViewController.h"
#import "TwitterClient.h"


@interface menuViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property TwitterClient *client;
@property (nonatomic,strong) NSMutableDictionary *tweetsArray;
@end

@implementation menuViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.client = [TwitterClient instance];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"MENU VIEW DID LOAD......");
    [self.client verifyCredentials:^ (AFHTTPRequestOperation *operation, id responseObject){
        
        //NSLog(@"response: %@", responseObject);
        self.tweetsArray = responseObject;
        
        NSLog(@" %@", self.tweetsArray[@"name"]);
        NSLog(@" %@", self.tweetsArray[@"screen_name"]);
        self.displayName.text = self.tweetsArray[@"name"];
        self.name.text = self.tweetsArray[@"screen_name"];
        
        NSString *url = [self.tweetsArray[@"profile_image_url"] stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        self.profileImage.image =[UIImage imageWithData:imageData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"response error: %@", error);
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)profileButton:(id)sender {
    NSLog(@"profile");
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"profile"
     object:self];
}

- (IBAction)menuButton:(id)sender {
    NSLog(@"mentions");
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"mentions"
     object:self];
}
- (IBAction)tweetsButton:(id)sender {
    NSLog(@"tweets");
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"tweets"
     object:self];
    
}


@end
