//
//  RecipesModel.h
//  Recipes
//
//  Created by xueyognwei on 2017/8/31.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodModel.h"


@interface RecipesModel : NSObject

/**
 菜谱的名字
 */
@property (nonatomic,copy) NSString *name;

/**
 菜谱的配料
 */
@property (nonatomic,copy) NSString *seasoning;


/**
 菜谱的食材
 */
@property (nonatomic,strong) NSArray *ingredients;


/**
 操作步骤
 */
@property (nonatomic,strong) NSArray *steps;

-(FoodModel *)getfoodModelWithFoodName:(NSString *)foodName;
@end
