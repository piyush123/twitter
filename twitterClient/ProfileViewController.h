//
//  ProfileViewController.h
//  twitterClient
//
//  Created by piyush shah on 7/2/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property NSString *userProfile;
@property NSString *userName;

@end
