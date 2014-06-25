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
#import <UIImageView+AFNetworking.h>

@interface TweetsViewController () 

@property (weak, nonatomic) IBOutlet UITableView *tweetsTable;

@property (strong, nonatomic) NSMutableArray *tweets;

@property (strong, nonatomic) Tweet *tweetModel;

@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        TwitterClient *client = [TwitterClient instance];
        [client homeTimelineWithSuccess:^ (AFHTTPRequestOperation *operation, id responseObject){
            //NSLog(@"tweets table view controller");
            //NSLog(@"response: %@", responseObject);
            self.tweets = responseObject;
            NSLog(@"array count: %d", [self.tweets count]);
            //NSLog(@"%@", self.tweets[1]);
            [self.tweetsTable reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"response error: %@", error);
        }];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.tweetsTable setDelegate:self];
    
    self.tweetsTable.rowHeight = 130;
    
    self.tweetsTable.dataSource = self;

    
    UINib *tweetCellNib = [UINib nibWithNibName:@"tweetCell" bundle:nil];
    
    [self.tweetsTable registerNib:tweetCellNib forCellReuseIdentifier:@"tweetCell"];
    
    [self.tweetsTable reloadData];
    
    
    
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
    
    self.tweetModel = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:self.tweets[indexPath.row] error:NULL];
    tweetCell.tweetText.text = self.tweetModel.text;
    tweetCell.retweeted.text = self.tweetModel.retweeted;
    tweetCell.tweetTime.text = self.tweetModel.created;
    tweetCell.user.text =  [NSString stringWithFormat:@"%@ @%@", self.tweetModel.name, self.tweetModel.screenname ];
    
    NSLog(@"name Label: %@", self.tweetModel.profile_image_url);
    
    NSString *imgURL = [self.tweetModel.profile_image_url stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
