//
//  RefrigeratorTableViewController.h
//  Recipes
//
//  Created by 薛永伟 on 2017/8/26.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodModel.h"

@interface FoodTableViewController : UITableViewController
@property (nonatomic,assign) FoodType foodType;
-(NSString *)foodStringOfType:(FoodType)type;
@end
