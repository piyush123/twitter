//
//  ComposeViewController.m
//  
//
//  Created by piyush shah on 6/26/14.
//
//

#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Utils.h"
#import <UIImageView+AFNetworking.h>

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UITextView *statusUpdate;
@property (weak, nonatomic) IBOutlet UIButton *saveUpdate;

@property (weak, nonatomic) IBOutlet UIButton *tweet;

@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIBarButtonItem *cancelButton= [[UIBarButtonItem alloc] initWithTitle:@"cancel"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(cancel:)];
        
        self.navigationItem.rightBarButtonItem = cancelButton;
        
       // self.statusUpdate.delegate = self;
        
        [self.tweet addTarget:self action:@selector(updateStatus:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}


- (void)updateStatus: (id) sender {
      NSLog(@"status Update");
    TwitterClient *client = [TwitterClient instance];
    
    NSString *update = self.statusUpdate.text;
    
    [client updateStatus:update :^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
        [self dismissViewControllerAnimated:YES completion:nil];
    } :^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"response error: %@", error);
        self.statusUpdate.text = @"Error posting the tweet";
    }];
    
}

- (void)cancel: (id) sender {
    NSLog(@"Cancel Pressed");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    User *currentUser = [User currentUser];
    NSLog(@"current user %@", currentUser);
    [Utils setImageWithUrl:[[User currentUser] profile_image_url] inImageView:self.profileImage];
    
    self.name.text = currentUser.name;
    self.screenName.text = currentUser.screenName;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
