//
//  ChatMsgCellTableViewCell.m
//  ChatTest
//
//  Created by umeshwarrao yennam on 8/14/15.
//  Copyright (c) 2015 UmeshYennam. All rights reserved.
//

#import "ChatMsgCellTableViewCell.h"

@implementation ChatMsgCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) hideMyItem{
    self.myPic.hidden = YES;
    self.myName.hidden = YES;
    self.myMsg.hidden = YES;
    
    self.frdPic.hidden = NO;
    self.frdName.hidden = NO;
    self.frdMsg.hidden = NO;

}

- (void) hideFrdItem{
    self.frdPic.hidden = YES;
    self.frdName.hidden = YES;
    self.frdMsg.hidden = YES;
    
    self.myPic.hidden = NO;
    self.myName.hidden = NO;
    self.myMsg.hidden = NO;

}


@end
