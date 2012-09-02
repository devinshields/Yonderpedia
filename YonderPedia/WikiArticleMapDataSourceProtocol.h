//
//  WikiArticleMapDataSourceProtocol.h
//  YonderPedia
//
//  Created by Devin Shields on 2/4/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol WikiArticleMapDataSourceProtocol <NSObject>
@required
@property (nonatomic,strong) NSArray *articles;
-(CLLocation*)currentMapCenterpoint;
-(void)refreshArticlesAtMostRecentLocation;
-(void)refreshArticlesAtLocation:(CLLocation*)clLoc;
-(void)clearArticles;
@end
