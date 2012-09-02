//
//  RootModalViewController.h
//  YonderPedia
//
//  Created by Devin Shields on 2/3/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WikiGeolocationArticleFetcher.h"
#import "WIkiArticleTableViewController.h"
#import "WikiArticleMapDataSourceProtocol.h"

@interface RootModalViewController : UIViewController <CLLocationManagerDelegate,WikiArticleTableDataSourceProtocol,WikiArticleMapDataSourceProtocol>
@property (nonatomic,strong) NSArray *articles;
-(void)refreshArticlesAtMostRecentLocation;
-(void)refreshArticlesAtLocation:(CLLocation*)clLoc;
-(CLLocation*)currentMapCenterpoint;
@end
