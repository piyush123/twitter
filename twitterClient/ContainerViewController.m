//
//  ContainerViewController.m
//  twitterClient
//
//  Created by piyush shah on 7/2/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import "ContainerViewController.h"

#define kMargin 36

@interface ContainerViewController ()
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)onPan:(id)sender;

@property (strong, nonatomic) UIView *childView;

@property (strong, nonatomic) NSMutableArray  *viewControllers;

@property (nonatomic, strong) UINavigationController *nav_c;
@property (nonatomic, strong) UIViewController *profile_vc;
@property (nonatomic, strong) UIViewController *tweet_vc;
@property (nonatomic, strong) UIViewController *menu_vc;
@property (nonatomic, strong) UIViewController *mentions_vc;
@property (nonatomic, strong) UIBarButtonItem *tweetButton;
@property (nonatomic, strong) UIBarButtonItem *menuButton;
@end

@implementation ContainerViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.viewControllers = [[NSMutableArray alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(mentionsReceived:)
                                                     name:@"mentions"
                                                   object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tweetsReceived:)
                                                     name:@"tweets"
                                                   object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(profileReceived:)
                                                     name:@"profile"
                                                   object:nil];
        
    }
    return self;
}

- (void) mentionsReceived:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"mentions"])
        
    {
        
        NSLog (@"Successfully received the test notification!");
        
        [self.tweet_vc.view addSubview:self.mentions_vc.view];
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.childView.frame = CGRectMake(0, 0, self.childView.frame.size.width, self.childView.frame.size.height);
            
        } completion:nil];
        
    }
    else
    {
        NSLog(@"got mentions error");
    }
    
    
}

- (void) tweetsReceived:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"tweets"])
        
    {
        
        NSLog (@"Successfully received the test notification!");
        
        [self.mentions_vc.view removeFromSuperview];
        [self.profile_vc.view removeFromSuperview];
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            
        } completion:nil];
        
    }
    
}

- (void) profileReceived:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"profile"])
        
    {
        
        NSLog (@"Successfully received the test notification!");
        [self.mentions_vc.view removeFromSuperview];
        [self.tweet_vc.view addSubview:self.profile_vc.view];
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            
        } completion:nil];
        
    }
    
    
}


- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    
    //NSLog(@"on pan.....");
    self.childView = self.menuView;
    
    CGPoint velocity = [sender velocityInView:self.view];
    
    CGPoint translate = [sender translationInView:self.view];
    CGRect newFrame = self.childView.frame;
    newFrame.origin.x += translate.x;
    newFrame.origin.y += translate.y;
    
    //self.touched.frame = newFrame;
    if (sender.state == UIGestureRecognizerStateBegan ) {
        CGPoint transition = [sender locationInView:self.view];
        transition.y = 0;
        self.childView.frame = CGRectMake(transition.x, 0, self.childView.frame.size.width, self.childView.frame.size.height);
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        
        //childView.frame = CGRectMake(childView.frame.size.width-kSlideMargin, 0, childView.frame.size.width, childView.frame.size.height);
        if (velocity.x >= 20) {
            
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:5 options:0 animations:^{
                if (velocity.x >= 20) {
                    //view.center = leftPoint;
                    self.childView.frame = CGRectMake(self.childView.frame.size.width-kMargin, 0, self.childView.frame.size.width, self.childView.frame.size.height);
                    
                }
            } completion:nil];
        } else {
            NSLog(@"velocity %f", velocity.x);
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                //if (velocity.x >= -10) {
                self.childView.frame = CGRectMake(0, 0, self.childView.frame.size.width, self.childView.frame.size.height);
                //}
            } completion:nil];
        }
    }
    
    
    
}


- (void) addViewController:(UIViewController *)vc
{
    [self.viewControllers addObject:vc];
    
    NSLog(@"vc %@", self.viewControllers);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"GOT ContainerViewController");
    
    NSLog(@"view contr %@",self.viewControllers );
    
    self.profile_vc = self.viewControllers[0];
    self.tweet_vc = self.viewControllers[1];
    self.menu_vc = self.viewControllers[2];
    self.mentions_vc = self.viewControllers[3];
    self.nav_c = self.viewControllers[4];
    
    // setup nav
    [self addChildViewController:self.nav_c];
    self.nav_c.view.frame = self.menuView.frame;
    [self.menuView addSubview:self.nav_c.view];
    [self.nav_c didMoveToParentViewController:self];
    
    // setup menu
    [self addChildViewController:self.menu_vc];
    self.menu_vc.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.menu_vc.view];
    [self.menu_vc didMoveToParentViewController:self];
    
    [self setTweetButton];
    [self setMenuButton];
    //[self setTestButton];
    
    // mentions
    // menu
    // tweets
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setTweetButton
{
    self.tweetButton= [[UIBarButtonItem alloc] initWithTitle:@"tweet"
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(composeTweet:)];
}


-(void) setMenuButton
{
    
    UIImage *menuImage = [UIImage imageNamed:@"menu.png"];
    
    UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
    
    menu.bounds = CGRectMake( 0, 0, 24, 24);
    
    [menu setImage:menuImage forState:UIControlStateNormal];
    
    self.menuButton = [[UIBarButtonItem alloc] initWithCustomView:menu];
}

-(void) showView:(id)sender
{
    NSLog(@"show view");
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
@end
