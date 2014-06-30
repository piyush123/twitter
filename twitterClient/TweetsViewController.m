//
//  TweetsViewController.m
//  
//
//  Created by piyush shah on 6/24/14.
//

#import "TweetsViewController.h"
#import "tweetCell.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"
#import <UIImageView+AFNetworking.h>
#import <UIRefreshControl+AFNetworking.h>
#import "DetailTweetViewController.h"


@interface TweetsViewController () 

@property (weak, nonatomic) IBOutlet UITableView *tweetsTable;

@property (strong, nonatomic) NSMutableArray *tweets;

@property (strong, nonatomic) Tweet *tweetModel;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
     
        
    }
    return self;
}

- (id)initWithAPI:(NSString *)api {
    
    self = [super init];

    if (self)
    {
    TwitterClient *client = [TwitterClient instance];
        
    if ([api  isEqual: @"tweets"])
    {
        [client homeTimeline:^ (AFHTTPRequestOperation *operation, id responseObject){
        //NSLog(@"tweets table view controller");
        //NSLog(@"response: %@", responseObject);
        self.tweets = responseObject;
        NSLog(@"array count: %d", [self.tweets count]);
        //NSLog(@"%@", self.tweets[1]);
        [self.tweetsTable reloadData];
        
        } :^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"response error: %@", error);
        }];
    }
       else
       {
           [client mentionsTimeline:^ (AFHTTPRequestOperation *operation, id responseObject){
               //NSLog(@"tweets table view controller");
               //NSLog(@"response: %@", responseObject);
               self.tweets = responseObject;
               NSLog(@"array count: %d", [self.tweets count]);
               //NSLog(@"%@", self.tweets[1]);
               [self.tweetsTable reloadData];
               
           } :^(AFHTTPRequestOperation *operation, NSError *error){
               NSLog(@"response error: %@", error);
           }];
       }
        
    }
    return self;

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tweetsTable.rowHeight = 130;
    
    self.tweetsTable.dataSource = self;
    
    UINib *tweetCellNib = [UINib nibWithNibName:@"tweetCell" bundle:nil];
    
    [self.tweetsTable registerNib:tweetCellNib forCellReuseIdentifier:@"tweetCell"];
    
    
    [self.tweetsTable setDelegate:self];
    
    UIBarButtonItem *tweetButton= [[UIBarButtonItem alloc] initWithTitle:@"tweet"
            style:UIBarButtonItemStyleDone
            target:self
            action:@selector(composeTweet:)];
    
    NSLog(@"added tweetBtn");
    
    UIImage *menuImage = [UIImage imageNamed:@"menu.png"];
    
    UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
    
    menu.bounds = CGRectMake( 0, 0, 24, 24);
    
    [menu setImage:menuImage forState:UIControlStateNormal];
    
     UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(composeTweet:)];
   
    self.navigationItem.leftBarButtonItem = menuBtn;
    self.navigationItem.rightBarButtonItem = tweetButton;
    
    
    NSLog(@"added menuBtn");
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [self.tweetsTable addSubview:self.refreshControl];
    
}

- (void) refreshView:(id)sender{
    [self getTweets];
    [(UIRefreshControl *)sender endRefreshing];
}


- (void)menuGo: (id) sender {
    
    NSLog(@"menu go");
}
- (void)composeTweet: (id) sender {
    
    ComposeViewController *composeViewController = [[ComposeViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:composeViewController];
    
    navigationController.navigationBar.barTintColor =[UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    
    navigationController.navigationBar.alpha = 0.50;
    
    navigationController.navigationBar.translucent = NO;
    
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    
    [self presentViewController:navigationController animated:YES completion: nil];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    NSLog(@"RETURNING count %d", self.tweets.count);
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@" in cellForRowAtIndexPath" );
    
    TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    
  //  Tweet *tweet = self.tweets[indexPath.row];
    
  //  [TweetCell setTweet:tweet];
    
 //   NSLog(@" the data %@", self.tweets[indexPath.row]);
    
    self.tweetModel = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:self.tweets[indexPath.row] error:NULL];
   // NSLog(@"got tweetmodel text %@", self.tweetModel.text);
    
 //   NSLog(@"got tweetmodel  %@", self.tweetModel);
    tweetCell.tweetText.text = self.tweetModel.text;
  //  tweetCell.retweeted.text = self.tweetModel.retweeted;
    
  //  NSLog(@"got tweetmodel retweeted text %@", self.tweetModel.retweeted);
    
    tweetCell.tweetTime.text =  self.tweetModel.created;
    tweetCell.user.text =  [NSString stringWithFormat:@"%@ @%@", self.tweetModel.name, self.tweetModel.screenName ];
    
    NSLog(@"profile url: %@", self.tweetModel.profileImageURL);
    
    NSString *imgURL = [self.tweetModel.profileImageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    
    NSURL   *imageURL   = [NSURL URLWithString:imgURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    UIImage *placeholderImage; // = [UIImage imageNamed:@"yelp_placeholder.png"];
    
    __weak UITableViewCell *weakCell = tweetCell;
    
    
    [tweetCell.picture setImageWithURLRequest:request
                                 placeholderImage:placeholderImage
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              
                                              weakCell.imageView.image = image;
                                              weakCell.imageView.layer.cornerRadius = 15.0;
                                              weakCell.layer.masksToBounds = YES;
                                              
                                              [weakCell setNeedsLayout];
                                              
                                              
                                          } failure:nil];
    
    
    return tweetCell;
    
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    DetailTweetViewController *detailTweetViewController = [[DetailTweetViewController alloc] init];
    detailTweetViewController.tweet = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:self.tweets[indexPath.row] error:NULL];
    [self.navigationController pushViewController:detailTweetViewController animated:YES];
}

- (void) getTweets
{
    
    NSLog(@"getting data from refresh");
    TwitterClient *client = [TwitterClient instance];
    [client homeTimeline:^ (AFHTTPRequestOperation *operation, id responseObject){
        //NSLog(@"tweets table view controller");
        //NSLog(@"response: %@", responseObject);
        self.tweets = responseObject;
        NSLog(@"REFRESH array count: %d", [self.tweets count]);
        //NSLog(@"%@", self.tweets[1]);
        [self.tweetsTable reloadData];
        
    } :^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"response error: %@", error);
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
