//
//  WIkiArticleTableViewController.m
//  YonderPedia
//
//  Created by Devin Shields on 2/3/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import "WIkiArticleTableViewController.h"
#import "WikiGeolocationArticleFetcher.h"
#import "WebWikiArticleViewController.h"

@implementation WIkiArticleTableViewController
@synthesize tableViewDataScource = _tableViewDataScource;


// if there's no data source set, use the presenting VC
-(id<WikiArticleTableDataSourceProtocol>)tableViewDataScource{
    if(!_tableViewDataScource){
        _tableViewDataScource = (id)[self presentingViewController];
    }
    return _tableViewDataScource;
}
// asks the datasource to refresh and update the table
- (IBAction)refreshPushed:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    // async to allow UI while fetching & async set self.articles to allow notifications
    dispatch_queue_t downloadQueue = dispatch_queue_create("Wiki Article geolocation API request", NULL);
    dispatch_async(downloadQueue, ^{
        [self.tableViewDataScource refreshArticlesAtMostRecentLocation];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = sender;
            [self.tableView reloadData];
        });
    });
    dispatch_release(downloadQueue);
} 







- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *articles = [self.tableViewDataScource articles];
    return [articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Wiki Article Cell Prototype";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // get the root view controller's model data`
    NSArray *articles = [self.tableViewDataScource articles];
    NSDictionary *article = [articles objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [article objectForKey:WIKI_ARTICLE_TITLE];
    cell.detailTextLabel.text = [article objectForKey:WIKI_ARTICLE_TYPE];
    
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    NSDictionary *article = [[self.tableViewDataScource articles] objectAtIndex:[self.tableView indexPathForCell:sender].row];
    if ([segue.destinationViewController respondsToSelector:@selector(setUrlString:)]) {
        NSString *url = [NSString stringWithFormat:@"%@%@",@"http://en.m.wikipedia.org/w/index.php?curid=",[article objectForKey:WIKI_ARTICLE_ID]];
        NSLog(@"\n\n%@\n\n",url);
        [segue.destinationViewController performSelector:@selector(setUrlString:) withObject:url];
    }
}









/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
