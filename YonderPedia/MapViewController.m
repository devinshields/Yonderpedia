//
//  MapViewController.m
//  WikipediaNearYou
//
//  Created by Devin Shields on 2/2/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import "MapViewController.h"
#import "ArticleAnnotation.h"

@interface MapViewController() <MKMapViewDelegate>
@property (nonatomic,strong) NSMutableArray *annotations;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL isFirstTimeTheMapLoads;
- (NSMutableArray *)mapAnnotations;
-(void)zoomToCurrentLocation;
@end

#pragma mark - UpdateSetters
@implementation MapViewController
@synthesize mapViewDataSource = _mapViewDataSource;
@synthesize annotations = _annotations;
@synthesize mapView = _mapView;
@synthesize isFirstTimeTheMapLoads = _isFirstTimeTheMapLoads;


#pragma mark - buton functions
// fetch wiki data from the current user location, update everything
- (IBAction)refreshPressed:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    // async to allow UI while fetching & async set self.articles to allow notifications
    dispatch_queue_t downloadQueue = dispatch_queue_create("Wiki Article geolocation API request", NULL);
    dispatch_async(downloadQueue, ^{
        CLLocationCoordinate2D loc = self.mapView.centerCoordinate;
        CLLocation *clLoc = [[CLLocation alloc] initWithLatitude:loc.latitude longitude:loc.longitude];
        [self.mapViewDataSource refreshArticlesAtLocation:clLoc];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = sender;
            self.annotations = [self mapAnnotations];
        });
    });
    dispatch_release(downloadQueue);
}

#pragma mark - datasource getter
// if there's no data source set, use the presenting VC
-(id<WikiArticleMapDataSourceProtocol>)mapViewDataSource{
    if(!_mapViewDataSource){
        _mapViewDataSource = (id)[self presentingViewController];
    }
    return _mapViewDataSource;
}
#pragma mark - Map Functions
- (void)updateMapView{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
}
- (void)setMapView:(MKMapView *)mapView{
    _mapView = mapView;
    [self updateMapView];
}
- (void)setAnnotations:(NSMutableArray *)annotations{
    // always include the user's current location in the annotations
    //[annotations addObject:[self.mapView userLocation]];
    
    _annotations = annotations;
    [self updateMapView];
}

#pragma mark - clear the map of all articles
- (IBAction)clearPressed:(id)sender {
    [self.mapViewDataSource clearArticles];
    self.annotations = nil;
}


#pragma mark - data-to-view components
- (NSMutableArray *)mapAnnotations{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.mapViewDataSource.articles count]];
    for (NSDictionary *article in self.mapViewDataSource.articles) {
        [annotations addObject:[ArticleAnnotation annotationForArticle:article]];
    }
    return annotations;
}
#pragma mark - MKMapViewDelegate
- (void)segueToWebViewController:(UIButton*)sender{
    [self performSegueWithIdentifier:@"SegueToWebViewController" sender:self];
}
#pragma mark - Segue stuff
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController respondsToSelector:@selector(setUrlString:)]) {
        ArticleAnnotation *selectedAnnotation = [[self.mapView selectedAnnotations] lastObject];
        NSString *url = [NSString stringWithFormat:@"%@%@",@"http://en.m.wikipedia.org/w/index.php?curid=",[selectedAnnotation.articleDict objectForKey:WIKI_ARTICLE_ID]];
        NSLog(@"\n\n   --- WebViewController Segue to:  %@\n\n",url);
        [segue.destinationViewController performSelector:@selector(setUrlString:) withObject:url];
    }
}



#pragma mark - viewForAnnotation, creates custom annotations
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    MKPinAnnotationView *aView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        // a blank image for now
        //aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(segueToWebViewController:) forControlEvents:UIControlEventTouchUpInside];
        aView.rightCalloutAccessoryView = rightButton;
    }
    
    // reset pin color
    NSString *placeType = [annotation subtitle];
    aView.pinColor = MKPinAnnotationColorRed;
    if([placeType isEqualToString:@"edu"] || [placeType isEqualToString:@"city"]){
        aView.pinColor = MKPinAnnotationColorGreen; // cities & schools in green
    }
    if([placeType isEqualToString:@"landmark"]){
        aView.pinColor = MKPinAnnotationColorPurple; // landmarks in purple
    }
    aView.annotation = annotation;
    //[(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    return aView;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView{
    //UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    //[(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
    NSLog(@"didSelectAnnotationView - pin pressed: %@", [aView.annotation title]);
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
}

#pragma mark - View Controller Lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    self.isFirstTimeTheMapLoads = YES;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.annotations = [self mapAnnotations];
}
- (void)viewDidUnload{
    //[self setMapView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}
-(void)zoomToCurrentLocation{
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance([self.mapViewDataSource currentMapCenterpoint].coordinate,MAP_VIEW_CONTROLLER_AUTO_ZOOM_DISTANCE, MAP_VIEW_CONTROLLER_AUTO_ZOOM_DISTANCE) animated:YES];
}

- (IBAction)centerButtonPushed:(id)sender {
    
    [self zoomToCurrentLocation];
    
}


// auto map zoom
- (void)viewDidAppear:(BOOL)animated{
    if(self.isFirstTimeTheMapLoads){
        [self zoomToCurrentLocation];
        self.isFirstTimeTheMapLoads = NO;
    }
}









#pragma mark - Autorotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}
@end
