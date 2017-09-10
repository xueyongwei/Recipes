//
//  RecipersRecomendHelper.h
//  Recipes
//
//  Created by xueyognwei on 2017/8/31.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipesManager.h"
#import "RecipesDetailViewController.h"
@interface RecipersRecomendHelper : NSObject

/**
 根据给出的食材，推荐出以个菜单

 @param foods 食材数组
 @return 菜单
 */
+(RecipesModel *)recommendRecipWithFoods:(NSArray *)foods;

/**
 智能分析，推荐一个菜单
 
 @return 菜单
 */
+(RecipesModel *)recommendRecipWithIntelligentAnalysis;

/**
 找到用冰箱里的食材可以做的菜谱
 
 @param recipes 菜谱们
 @return 想要的菜谱们
 */
+(NSArray <RecipesModel*>*)findCanMakeByRefifoodsWithRecipes:(NSArray <RecipesModel*>*)recipes;

/**
 包含给出食材的菜单们
 
 @param foods 食材们
 @return 菜单们
 */
+(NSArray *)recipesCotainFoods:(NSArray <FoodModel *>*)foods;
@end
