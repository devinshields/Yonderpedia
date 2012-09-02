//
//  WebWikiArticleViewController.m
//  YonderPedia
//
//  Created by Devin Shields on 2/4/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import "WebWikiArticleViewController.h"

@interface WebWikiArticleViewController()
@property (nonatomic,strong) id refreshButton;
@end

@implementation WebWikiArticleViewController
@synthesize urlString = _urlString;
@synthesize refreshButton = _refreshButton;
@synthesize webView = _webView;

- (IBAction)actionButtonPushed:(id)sender {
    
}




- (IBAction)refreshPushed:(id)sender {
    self.refreshButton = sender;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self urlString]]]];
    NSLog(@"\n\n   --- Requested URL Path:  %@   ---\n\n",self.webView.request.URL.path);
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
}
// callback for the web view
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //update the refresh button and the urlRequest
    self.navigationItem.rightBarButtonItem = self.refreshButton;
}
-(void)setup{
    self.webView.delegate = self;
    self.refreshButton = self.navigationItem.rightBarButtonItem;
    [self refreshPushed:self.refreshButton];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueToWebOptionsViewController"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setUrl:)]) {
            [segue.destinationViewController performSelector:@selector(setUrl:) withObject:self.urlString];
        }
    } 
}





@end
