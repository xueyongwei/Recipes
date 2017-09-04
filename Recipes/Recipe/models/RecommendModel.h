//
//  RecommendModel.h
//  Recipes
//
//  Created by 薛永伟 on 2017/9/2.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipesModel.h"
#import "FoodModel.h"
@interface RecommendModel : NSObject

/**
 推荐指数
 */
@property (nonatomic,assign) CGFloat priority;


/**
 推荐的菜单
 */
@property (nonatomic,strong) RecipesModel *recipe;


/**
 类方法，生成某一个菜单的推荐模型
 
 @param recipe 菜单
 @param foods 选择的食物
 @return 推荐模型
 */
+(RecommendModel *)recommendModelWithRecipe:(RecipesModel *)recipe andFoods:(NSArray *)foods;

/**
 计算此菜单推荐指数
 */
-(void)calculationPriority;

@end
