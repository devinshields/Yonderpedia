//
//  RootViewController.m
//  YonderPedia
//
//  Created by Devin Shields on 2/3/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import "RootViewController.h"


@interface RootViewController()
@property (nonatomic,strong) NSArray *articles;
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic,strong) NSMutableArray *locationMeasurements;
@end

@implementation RootViewController
@synthesize articles = _articles;
@synthesize locationManager = _locationManager;
@synthesize locationMeasurements = _locationMeasurements;


-(NSMutableArray*)locationMeasurements{
    if(!_locationMeasurements){
        _locationMeasurements = [[NSMutableArray alloc] init];
    }
    return _locationMeasurements;
}

// all the Location manager stuff is here
-(CLLocationManager*)locationManager{
    if(!_locationManager){
        NSLog(@"%@",@"\n\n   Starting location manager");
        // alloc/init, set the delegate & desired accuracy, and start 'er up
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [_locationManager startUpdatingLocation];
        NSLog(@"%@",@"   Location manager started\n");
    }
    return _locationManager;
}

// makes a wikipedia geolocation API request
-(void)fetchWikiGeolocationArticles:(CLLocation *)queryLocation{
    NSLog(@"%@",@"\n\n   -- Start WikiFetch --");
    self.articles = [WikiGeolocationArticleFetcher fetchWikiArticlesAtGeolocation:queryLocation];
    //NSLog(@"\n\n # of articles: %i \n\n",[[self articles] count]);
    NSLog(@"%@",@"\n   -- WikiFetch Complete --");
};

// this method is ONLY called by self.locationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [self.locationMeasurements addObject:newLocation];
    NSLog(@"\n\n   Latitude: %f   Longitude: %f",[newLocation coordinate].latitude,[newLocation coordinate].longitude);
    NSLog(@"   Location Array Count: %i",[self.locationMeasurements count]);
    
    // trigger an API call on the first location measurment arrivial
    if(!self.articles && [self.locationMeasurements count] > 0){
        [self fetchWikiGeolocationArticles:newLocation];
    }
    
    //kill the location maager if we have articles
    if(self.articles){
        [_locationManager stopUpdatingLocation];
    }
}

// calls to start the location manager cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self locationManager];
}    


#pragma mark - View lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
