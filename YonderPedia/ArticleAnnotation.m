//
//  ArticleAnnotation.m
//  WikipediaNearYou
//
//  Created by Devin Shields on 2/2/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import "ArticleAnnotation.h"

@implementation ArticleAnnotation
@synthesize articleDict = _articleDict;

+ (ArticleAnnotation *)annotationForArticle:(NSDictionary *)articleDict{
    ArticleAnnotation *annotation = [[ArticleAnnotation alloc] init];
    annotation.articleDict = articleDict;
    return annotation;
}

#pragma mark - MKAnnotation
- (NSString *)title
{
    return [self.articleDict objectForKey:WIKI_ARTICLE_TITLE];
}

- (NSString *)subtitle
{
    return [self.articleDict valueForKeyPath:WIKI_ARTICLE_TYPE];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.articleDict objectForKey:WIKI_ARTICLE_LATITUDE] doubleValue];
    coordinate.longitude = [[self.articleDict objectForKey:WIKI_ARTICLE_LONGITUDE] doubleValue];
    return coordinate;
}
@end
