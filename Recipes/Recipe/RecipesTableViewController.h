//
//  RecipesTableViewController.h
//  Recipes
//
//  Created by 薛永伟 on 2017/8/26.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RecipesDetailViewController.h"
@interface RecipesTableViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray *dataSource;
@end
