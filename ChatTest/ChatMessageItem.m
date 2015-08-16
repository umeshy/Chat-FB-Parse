//
//  ChatMessageItem.m
//  ChatTest
//
//  Created by umeshwarrao yennam on 8/14/15.
//  Copyright (c) 2015 UmeshYennam. All rights reserved.
//

#import "ChatMessageItem.h"
#import <Parse/PFObject.h>
#import "ChatViewController.h"

@implementation ChatMessageItem

-(id)init:(ChatViewController*)cv{
    self.chatViewController = cv;
    return self;
}

-(void)setMsgObject:(PFObject*)obj{
    self.msgObj = obj;
    if(self.msgObj != nil){
        self.msgOwnerObj = obj[MSG_OWNER];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        self.msgTimeStamp = [formatter stringFromDate:[ self.msgObj createdAt]];
        PFFile *file = self.msgOwnerObj[@"profile_pic"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.profilePic = [UIImage imageWithData:data];
                [self.chatViewController reloadChatTable];
            }
        }];
    }
}

-(NSString*)getSenderName{
    if(self.msgOwnerObj != nil){
       return [self.msgOwnerObj username];
    }
    return nil;
}

-(UIImage*)getProfilePic{
    return self.profilePic;
}

-(NSString*)getChatMsg{
    if(self.msgObj != nil){
        return self.msgObj[MSG_TXT];
    }
    return nil;
}

-(NSString*)getTimeStamp{
    return self.msgTimeStamp;
}

@end
