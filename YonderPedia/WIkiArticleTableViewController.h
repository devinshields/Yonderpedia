//
//  WIkiArticleTableViewController.h
//  YonderPedia
//
//  Created by Devin Shields on 2/3/12.
//  Copyright (c) 2012 Shields Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WikiArticleTableDataSourceProtocol.h"

@interface WIkiArticleTableViewController : UITableViewController
@property (nonatomic,weak) id <WikiArticleTableDataSourceProtocol> tableViewDataScource;
@end
