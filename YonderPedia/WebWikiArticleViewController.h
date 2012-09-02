//
//  WebWikiArticleViewController.h
//  YonderPedia
//
//  Created by Devin Shields on 2/4/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebWikiArticleViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic,strong) IBOutlet UIWebView *webView;
@property (nonatomic,strong) NSString *urlString;
@end
