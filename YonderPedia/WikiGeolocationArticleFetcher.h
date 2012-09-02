//
//  WikiGeolocationArticleFetcher.h
//  YonderPedia
//
//  Created by Devin Shields on 2/2/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// fix these to match the wiki geoloc API
#define WIKI_ARTICLE_TITLE @"title"
#define WIKI_ARTICLE_LATITUDE @"lat"
#define WIKI_ARTICLE_LONGITUDE @"lng"
#define WIKI_ARTICLE_URL @"url"

#define WIKI_ARTICLE_DISTANCE @"distance"
#define WIKI_ARTICLE_ID @"id"
#define WIKI_ARTICLE_TYPE @"type"

@interface WikiGeolocationArticleFetcher : NSObject

+ (NSArray *)fetchWikiArticlesAtGeolocation:(CLLocation *)queryGeolocation;

@end
