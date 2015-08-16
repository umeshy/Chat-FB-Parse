//
//  ChatViewController.h
//  ChatTest
//
//  Created by umeshwarrao yennam on 8/14/15.
//  Copyright (c) 2015 UmeshYennam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Constance.h"

@interface ChatViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray* messageArray;
@property (strong, nonatomic) NSString *myUserId;
@property (strong, nonatomic) NSString *myUserName;
- (IBAction) sendMessage:(id)sender;
- (IBAction) logOut:(id)sender;
- (void) reloadChatTable;

@end
