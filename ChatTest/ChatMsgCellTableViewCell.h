//
//  ChatMsgCellTableViewCell.h
//  ChatTest
//
//  Created by umeshwarrao yennam on 8/14/15.
//  Copyright (c) 2015 UmeshYennam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMsgCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myMsg;
@property (weak, nonatomic) IBOutlet UILabel *frdMsg;
@property (weak, nonatomic) IBOutlet UIImageView *frdPic;
@property (weak, nonatomic) IBOutlet UIImageView *myPic;
@property (weak, nonatomic) IBOutlet UILabel *frdName;
@property (weak, nonatomic) IBOutlet UILabel *myName;
@property (weak, nonatomic) IBOutlet UILabel *msgTimeStamp;

- (void) hideMyItem;
- (void) hideFrdItem;

@end
