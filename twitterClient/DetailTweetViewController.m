//
//  DetailTweetViewController.m
//  
//
//  Created by piyush shah on 6/26/14.
//
//

#import "DetailTweetViewController.h"
#import "Tweet.h"
#import "Utils.h"

@interface DetailTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenname;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;

@end

@implementation DetailTweetViewController

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
    UIBarButtonItem *cancelButton= [[UIBarButtonItem alloc] initWithTitle:@"cancel"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(cancel:)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    NSLog(@"tweet %@", self.tweet);
    
    self.name.text = self.tweet.name;
    
    self.screenname.text = self.tweet.screenName;
    
    self.tweetText.text = self.tweet.text;
    
    NSString *profileUrl = self.tweet.profileImageURL;
    
    [Utils setImageWithUrl:profileUrl inImageView:self.profileImage];
    
    
}


- (void)cancel: (id) sender {
    NSLog(@"Cancel Pressed");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
