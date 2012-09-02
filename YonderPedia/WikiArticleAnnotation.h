//
//  WikiArticleAnnotation.h
//  YonderPedia
//
//  Created by Devin Shields on 2/3/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>



@interface WikiArticleAnnotation : NSObject <MKAnnotation>

+ (WikiArticleAnnotation *)annotationForArticle:(NSDictionary *)article; // Flickr photo dictionary

@property (nonatomic, strong) NSDictionary *article;

@end
