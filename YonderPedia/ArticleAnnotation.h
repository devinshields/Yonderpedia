//
//  ArticleAnnotation.h
//  WikipediaNearYou
//
//  Created by Devin Shields on 2/2/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WikiGeolocationArticleFetcher.h"

@interface ArticleAnnotation : NSObject <MKAnnotation>
+ (ArticleAnnotation *)annotationForArticle:(NSDictionary *)articleDict; // Wikipedia Artcle info in a dictionary
@property (nonatomic, strong) NSDictionary *articleDict;
@end