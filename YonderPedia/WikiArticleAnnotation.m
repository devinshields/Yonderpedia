//
//  WikiArticleAnnotation.m
//  YonderPedia
//
//  Created by Devin Shields on 2/3/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import "WikiArticleAnnotation.h"

@implementation WikiArticleAnnotation
@synthesize article = _article;

+ (WikiArticleAnnotation *)annotationForArticle:(NSDictionary *)article
{
    WikiArticleAnnotation *annotation = [[WikiArticleAnnotation alloc] init];
    annotation.article = article;
    return annotation;
}


#pragma mark - MKAnnotation

- (NSString *)title
{
    //return [self.article objectForKey:FLICKR_PHOTO_TITLE];
    return nil;
}

- (NSString *)subtitle
{
    //return [self.article valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    return nil;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    //coordinate.latitude = [[self.article objectForKey:FLICKR_LATITUDE] doubleValue];
    //coordinate.longitude = [[self.article objectForKey:FLICKR_LONGITUDE] doubleValue];
    //return coordinate;
    return coordinate;
}

@end
