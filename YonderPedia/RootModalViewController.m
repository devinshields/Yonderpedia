//
//  RootModalViewController.m
//  YonderPedia
//
//  Created by Devin Shields on 2/3/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import "RootModalViewController.h"

@interface RootModalViewController()
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic,strong) NSMutableArray *locationMeasurements;
-(NSArray*)fetchWikiArticlesAtGeolocation:(CLLocation *)queryLocation;
- (void)segueToModalTab;
@end

@implementation RootModalViewController
@synthesize articles = _articles;
@synthesize locationManager = _locationManager;
@synthesize locationMeasurements = _locationMeasurements;


#pragma mark - startup async callback function
-(void)setArticles:(NSArray *)articles{
    // when the first wiki results come back, segue to the tab view
    if(!_articles){
        _articles = articles;
        [self segueToModalTab];
        return;
    }
    // merge all new articles to the current list
    NSMutableSet *set = [NSMutableSet setWithArray:_articles];
    [set addObjectsFromArray:articles];
    _articles = [set allObjects];
}
-(void)clearArticles{
    _articles = [[NSArray alloc] init];
}

#pragma mark - location functions
// location history getter
-(NSMutableArray*)locationMeasurements{
    if(!_locationMeasurements){
        _locationMeasurements = [[NSMutableArray alloc] init];
    }
    return _locationMeasurements;
}
// create and start a location manager
-(CLLocationManager*)locationManager{
    if(!_locationManager){
        NSLog(@"%@",@"\n\n   --- Starting location manager --- \n\n");
        // alloc/init, set the delegate & desired accuracy, and start 'er up
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.purpose = @"Hit 'Ok' to find Wikipedia stuff near your location";
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [_locationManager startUpdatingLocation];
        NSLog(@"%@",@"\n\n   --- Location manager started ---\n\n");
    }
    return _locationManager;
}
// periodic callback for self.locationManager 
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [self.locationMeasurements addObject:newLocation];
    NSLog(@"\n\n   Latitude: %f   Longitude: %f",[newLocation coordinate].latitude,[newLocation coordinate].longitude);

    // on the first location lookup, auto query nearby articles
    if(!oldLocation){
        // async to allow UI while fetching & async set self.articles to allow notifications
        dispatch_queue_t downloadQueue = dispatch_queue_create("Wiki Article geolocation API request", NULL);
        dispatch_async(downloadQueue, ^{
            NSArray *articles = [self fetchWikiArticlesAtGeolocation:newLocation];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.articles = articles;
            });
        });
        dispatch_release(downloadQueue);
    }
}
// mapview datasource protocol function
-(CLLocation*)currentMapCenterpoint{
    return [self.locationMeasurements lastObject];
}

#pragma mark - Wiki Fetcher functions
// makes a wikipedia geolocation API request
-(NSArray*)fetchWikiArticlesAtGeolocation:(CLLocation *)queryLocation{
    NSLog(@"%@",@"\n\n   --- Start WikiFetch ---\n\n");
    NSArray *articles = [WikiGeolocationArticleFetcher fetchWikiArticlesAtGeolocation:queryLocation];
    NSLog(@"%@",@"\n\n   --- WikiFetch Complete ---\n\n");
    return articles;
};
// delegate method that allows child VCs to refresh articles
-(void)refreshArticlesAtMostRecentLocation{
    self.articles = [self fetchWikiArticlesAtGeolocation:[self.locationMeasurements lastObject]];
}
-(void)refreshArticlesAtLocation:(CLLocation*)clLoc{
    self.articles = [self fetchWikiArticlesAtGeolocation:clLoc];
}


#pragma mark - Segues
- (IBAction)segueButtonPresed:(id)sender {
    [self performSegueWithIdentifier:@"SegueToModalTab" sender:self];
}
- (void)segueToModalTab{
    [self performSegueWithIdentifier:@"SegueToModalTab" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueToModalTab"]) {
        //UIViewController *newController = segue.destinationViewController;
        // send messages to newController to prepare it to appear on screen
        // the segue will do the work of putting the new controller on screen
    } 
}

#pragma mark - ViewController lifecycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // STARTS HERE!
    [self locationManager];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
