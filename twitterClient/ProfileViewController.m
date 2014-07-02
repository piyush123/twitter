//
//  ProfileViewController.m
//  twitterClient
//
//  Created by piyush shah on 7/2/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "UserStats.h"
#import "Tweet.h"
#import <UIImageView+AFNetworking.h>
#import "tweetCell.h"


@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;

@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITableView *displayView;

@property TwitterClient *client;
@property UserStats *userStat;
@property (nonatomic,strong) NSMutableArray *tweetsArray;


@property Tweet *tweetModel;
@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"profileView" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if([self.userProfile isEqual:@"userprofile"]){
        [self.client userProfile:self.userName  success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            //NSLog(@"response: %@", responseObject);
            //[self dismissViewControllerAnimated:YES completion:nil];
            self.tweetsArray = responseObject;
            UserStats *userStat = [MTLJSONAdapter modelOfClass:UserStats.class fromJSONDictionary:self.tweetsArray[0] error:NULL];
            
            self.tweetCountLabel.text =  [NSString stringWithFormat:@"%@", userStat.tweetCount];
            self.followersLabel.text = [NSString stringWithFormat:@"%@", userStat.followersCount];
            self.followingLabel.text = [NSString stringWithFormat:@"%@", userStat.followingCount];
            
            NSString *url = [userStat.profileImageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userStat.profileImageURL]];
            self.profileImage.image =[UIImage imageWithData:imageData];
            
            NSData *backgroundImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userStat.backgroundImageURL]];
            self.backgroundImage.image =[UIImage imageWithData:backgroundImageData];
            [self.displayView reloadData];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"response error: %@", error);
            
        }];
    }
    else
    {

    [self.client userTimeLine:^ (AFHTTPRequestOperation *operation, id responseObject){
        //NSLog(@"response: %@", responseObject);
        self.tweetsArray = responseObject;
        UserStats *userStat = [MTLJSONAdapter modelOfClass:UserStats.class fromJSONDictionary:self.tweetsArray[0] error:NULL];
        
        self.tweetCountLabel.text =  [NSString stringWithFormat:@"%@", userStat.tweetCount];
        self.followersLabel.text = [NSString stringWithFormat:@"%@", userStat.followersCount];
        self.followingLabel.text = [NSString stringWithFormat:@"%@", userStat.followingCount];
        
        
        NSString *url = [userStat.profileImageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userStat.profileImageURL]];
        self.profileImage.image =[UIImage imageWithData:imageData];
        
        NSData *backgroundImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userStat.backgroundImageURL]];
        self.backgroundImage.image =[UIImage imageWithData:backgroundImageData];
        [self.displayView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"response error: %@", error);
    }];
    };


self.displayView.rowHeight = 120;

[self.displayView registerNib:[UINib nibWithNibName:@"tweetCell" bundle:nil] forCellReuseIdentifier: @"tweetCell"];

self.displayView.dataSource = self;

[self.displayView setDelegate:self];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetsArray.count;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select");
    
    
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"cell for row");
    
    TweetCell *displayCell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    
    self.tweetModel = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:self.tweetsArray[indexPath.row] error:NULL];
    NSLog(@" %@",self.tweetModel.retweeted);
       displayCell.user.text =  [NSString stringWithFormat:@"%@ @%@", self.tweetModel.name, self.tweetModel.screenName ];
    
    
    //   NSLog(@"name Label: %@", self.tweetModel.profileImageURL);
    
    NSString *imgURL = [self.tweetModel.profileImageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    
    NSURL   *imageURL   = [NSURL URLWithString:imgURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    UIImage *placeholderImage; // = [UIImage imageNamed:@"yelp_placeholder.png"];
    
    __weak UITableViewCell *weakCell = displayCell;
    
    
    [displayCell.picture setImageWithURLRequest:request
                                 placeholderImage:placeholderImage
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              
                                              weakCell.imageView.image = image;
                                              weakCell.imageView.layer.cornerRadius = 15.0;
                                              weakCell.layer.masksToBounds = YES;
                                              
                                              [weakCell setNeedsLayout];
                                              
                                              
                                          } failure:nil];
    
    return displayCell;
    
}



@end
