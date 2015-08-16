//
//  ChatViewController.m
//  ChatTest
//
//  Created by umeshwarrao yennam on 8/14/15.
//  Copyright (c) 2015 UmeshYennam. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatMessageItem.h"
#import "ChatMsgCellTableViewCell.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface ChatViewController ()
@property (strong, nonatomic) IBOutlet UITextField *sendMessageEditField;

@property (strong, nonatomic) IBOutlet UITableView *pastMessagesTableView;

@end

@implementation ChatViewController

@synthesize sendMessageEditField;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageArray = [[NSMutableArray alloc] init];
    self.sendMessageEditField.delegate = self;
    self.pastMessagesTableView.delegate = self;
    self.pastMessagesTableView.dataSource = self;
    self.pastMessagesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.pastMessagesTableView addGestureRecognizer:tap];
    [self.pastMessagesTableView addSubview:refreshControl];
    [self fetchMessages];
}

- (IBAction)sendMessage:(id)sender{

    NSString *msg = [sendMessageEditField.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    if ([msg length] <= 0 ) return;
    
    PFObject *msgObj = [PFObject objectWithClassName:@"chatMessage"];
    msgObj[@"msg"] = [sendMessageEditField text];
    msgObj[@"owner"] = [PFUser currentUser];
    [msgObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self fetchMessages];
            sendMessageEditField.text = @"";
        }
    }];
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self fetchMessages];
    [refreshControl endRefreshing];
}

- (void) didTapOnTableView:(UIGestureRecognizer*) recognizer {
    [self.sendMessageEditField resignFirstResponder];
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self scrollTableToBottom];
//    [self.sendMessageEditField resignFirstResponder];
//}
//


- (IBAction)logOut:(id)sender{
    [PFUser logOut];
    [[PFFacebookUtils session] close];
    [self reset];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)reset{
    [self.messageArray removeAllObjects];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self scrollTableToBottom];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing");
    double offset = self.view.frame.size.height*0.49 - textField.frame.origin.y;
    CGRect rect = CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
    
    [textField resignFirstResponder];
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    return NO;
}

- (void)reloadChatTable{
    [self.pastMessagesTableView reloadData];
    [self scrollTableToBottom];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.messageArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMsgCellTableViewCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"msgCell" forIndexPath:indexPath];
    [self initCell:messageCell forIndexPath:indexPath];
    return messageCell;
}

#pragma mark Method to configure the appearance of a message list prototype cell

- (void)initCell:(ChatMsgCellTableViewCell *)messageCell forIndexPath:(NSIndexPath *)indexPath {
    
    ChatMessageItem *chatMessage = self.messageArray[indexPath.row];
    if ([[chatMessage.msgOwnerObj objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        // It's my chat message
        messageCell.myPic.image = [chatMessage getProfilePic];
        messageCell.myName.text = [chatMessage getSenderName];
        messageCell.myMsg.text = [chatMessage getChatMsg];
        [messageCell hideFrdItem];
    } else {
        // It's friend chat message
        messageCell.frdPic.image = [chatMessage getProfilePic];
        messageCell.frdName.text = [chatMessage getSenderName];
        messageCell.frdMsg.text = [chatMessage getChatMsg];
        [messageCell hideMyItem];
    }
    
    messageCell.msgTimeStamp.text = [chatMessage getTimeStamp];
}

- (void)scrollTableToBottom {
    CGPoint offset = CGPointMake(0, self.pastMessagesTableView.contentSize.height -  self.pastMessagesTableView.frame.size.height);
    [self.pastMessagesTableView setContentOffset:offset animated:YES];
}

-(void)fetchMessages{
    
    [self.pastMessagesTableView reloadData];
    PFQuery *query = [PFQuery queryWithClassName:@"chatMessage"];
    [query includeKey:@"owner"];

    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *chatMessageArray, NSError *error) {
        if (!error) {

            [weakSelf.messageArray removeAllObjects];
            for (int i = 0; i < chatMessageArray.count; i++) {
                ChatMessageItem *msgItem = [[ChatMessageItem alloc] init:self];
                [msgItem setMsgObject:chatMessageArray[i]];
                [weakSelf.messageArray addObject:msgItem];
            }
            [weakSelf.pastMessagesTableView reloadData];  // Refresh the table view
            [weakSelf scrollTableToBottom];  // Scroll to the bottom of the table view
        }
    }];
    
}

- (void)dealloc {
    //Logout current user
    [PFUser logOut];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
