//
//  MapViewController.h
//  WikipediaNearYou
//
//  Created by Devin Shields on 2/2/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKGeometry.h>
#import <CoreLocation/CoreLocation.h>
#import "WikiArticleMapDataSourceProtocol.h"

#define MAP_VIEW_CONTROLLER_AUTO_ZOOM_DISTANCE 8000

@interface MapViewController : UIViewController
@property (nonatomic,weak) id <WikiArticleMapDataSourceProtocol> mapViewDataSource;

@end