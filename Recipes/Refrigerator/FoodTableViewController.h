//
//  RefrigeratorTableViewController.h
//  Recipes
//
//  Created by 薛永伟 on 2017/8/26.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodModel.h"
#define kSelectedFoodNoti @"kSelectedFoodNoti"
#define kDeSelectedFoodNoti @"kDeSelectedFoodNoti"
@interface FoodTableViewController : UITableViewController
@property (nonatomic,assign) FoodType foodType;
@property (nonatomic,strong) NSMutableArray *allFoods;
-(NSString *)foodStringOfType:(FoodType)type;
/**
 刷新数据
 */
-(void)refreshData;
@end
