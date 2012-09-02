//
//  WebOptionsTableViewController.h
//  YonderPedia
//
//  Created by Devin Shields on 2/5/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface WebOptionsTableViewController : UITableViewController <MFMailComposeViewControllerDelegate> 
{
	IBOutlet UILabel *message;
}

@property (nonatomic,strong) NSString *url;

@property (nonatomic, retain) IBOutlet UILabel *message;
-(IBAction)showPicker:(id)sender;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;

@end
