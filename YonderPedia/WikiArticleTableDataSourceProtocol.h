//
//  WikiArticleTableDataSourceProtocol.h
//  YonderPedia
//
//  Created by Devin Shields on 2/3/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WikiArticleTableDataSourceProtocol.h"

@protocol WikiArticleTableDataSourceProtocol <NSObject>

@required
@property (nonatomic,strong) NSArray *articles;
-(void)refreshArticlesAtMostRecentLocation;
-(void)refreshArticlesAtLocation:(CLLocation*)clLoc;

@end
