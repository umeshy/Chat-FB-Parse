//
//  ChatMessageItem.h
//  ChatTest
//
//  Created by umeshwarrao yennam on 8/14/15.
//  Copyright (c) 2015 UmeshYennam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Constance.h"
#import <Parse/PFConstants.h>
#import "ChatViewController.h"

@interface ChatMessageItem : NSObject
@property (nonatomic, strong) PFObject* msgObj;
@property (nonatomic, strong) PFUser* msgOwnerObj;
@property (nonatomic, strong) UIImage *profilePic;
@property (nonatomic, strong) NSString *msgTimeStamp;
@property (weak, atomic) ChatViewController *chatViewController;
- (id)init:(ChatViewController*)cv;
- (void)setMsgObject:(PFObject*)obj;
- (NSString*)getSenderName;
- (UIImage*)getProfilePic;
- (NSString*)getChatMsg;
- (NSString*)getTimeStamp;

@end
