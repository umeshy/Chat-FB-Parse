//
//  ViewController.h
//  ChatTest
//
//  Created by umeshwarrao yennam on 8/14/15.
//  Copyright (c) 2015 UmeshYennam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface ViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *logInBtn;

- (IBAction)loginButtonTouchHandler:(id)sender;

@end

