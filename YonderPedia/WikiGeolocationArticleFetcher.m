//
//  WikiGeolocationArticleFetcher.m
//  YonderPedia
//
//  Created by Devin Shields on 2/2/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import "WikiGeolocationArticleFetcher.h"

@implementation WikiGeolocationArticleFetcher

+ (NSArray *)fetchWikiArticlesAtGeolocation:(CLLocation *)queryGeolocation{

    NSString *query = @"http://api.wikilocation.org/articles?lat=";
    NSString *lat = [[NSNumber numberWithDouble:queryGeolocation.coordinate.latitude] stringValue];
    NSString *lng = [[NSNumber numberWithDouble:queryGeolocation.coordinate.longitude] stringValue];
    
    //NSLog(@"\n\n    %@ %@",lat,lng);
    
    // build the query string
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@", query, lat, @"&lng=", lng, @"&radius=20000"];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"\n\n  ---Calling API at URL:    \n     ---%@",str);
    
    // fetch the data over network
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:str] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    // transform the result an NSDictionary
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
    
    //if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    //NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    return [results valueForKeyPath:@"articles"];
}

@end
