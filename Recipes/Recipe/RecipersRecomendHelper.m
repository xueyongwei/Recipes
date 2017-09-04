//
//  RecipersRecomendHelper.m
//  Recipes
//
//  Created by xueyognwei on 2017/8/31.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "RecipersRecomendHelper.h"
#import "RecipesManager.h"
#import "RecommendModel.h"

@implementation RecipersRecomendHelper
/**
 根据给出的食材，推荐出以个菜单
 
 @param foods 食材数组
 @return 菜单
 */
+(RecipesModel *)recommendRecipWithFoods:(NSArray *)foods{
    RecipesModel *recipe = nil;
    //计算所有菜单对应已选食物的推荐模型
    NSArray *allRecipesRecommendModels = [self calculationllRecipesWithFoods:foods];
    //找到最佳菜谱
    recipe = [self bestRecipInRecommendModes:allRecipesRecommendModels];
    return recipe;
}


/**
 计算所有菜单对应已选食物的推荐模型

 @param foods 选择的食物
 @return 推荐模型数组
 */
+(NSArray *)calculationllRecipesWithFoods:(NSArray *)foods{
    NSMutableArray *allRecommends = [[NSMutableArray alloc]init];
    for (RecipesModel *recipe in [RecipesManager defaultManager].allRecipes) {
        //生成一个当前菜单的推荐模型
        RecommendModel *recommend = [RecommendModel recommendModelWithRecipe:recipe andFoods:foods];
        //计算推荐指数
        [recommend calculationPriority];
        NSLog(@"%@-%f",recommend.recipe.name,recommend.priority);
        //记录这个菜单的推荐模型
        [allRecommends addObject:recommend];
    }
    return allRecommends;
}


/**
 找到推荐指数最高的菜单

 @param recomends 菜单库
 @return 最佳菜单
 */
+(RecipesModel *)bestRecipInRecommendModes:(NSArray *)recomends{
    RecipesModel *bestRecipe = nil;
    NSInteger maxPriority = 0;
    for (RecommendModel *recomend in recomends) {
        if (recomend.priority>maxPriority) {
            maxPriority = recomend.priority;
            bestRecipe = recomend.recipe;
        }
    }
    return bestRecipe;
}

/**
 智能分析，推荐一个菜单
 
 @return 菜单
 */
+(RecipesModel *)recommendRecipWithIntelligentAnalysis
{
    RecipesModel *recipe = nil;
    NSArray *allFoodsInfri = [[DataBaseManager defaultManager] quryAllFoodsInRefigerator];
    recipe = [self recommendRecipWithFoods:allFoodsInfri];
    
    return recipe;
}
@end
