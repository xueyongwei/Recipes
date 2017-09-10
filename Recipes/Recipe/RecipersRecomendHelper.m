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
+(RecipesModel *)recommendRecipWithFoods:(NSArray <FoodModel *>*)foods{
    RecipesModel *recipe = nil;
    //计算所有菜单对应已选食物的推荐模型
    NSArray *allRecipesRecommendModels = [self calculationllRecipesWithFoods:foods];
    //找到最佳菜谱
    recipe = [self bestRecipInRecommendModes:allRecipesRecommendModels];
    return recipe;
}

/**
 根据给出的食材，推荐出以个菜单
 
 @param foods 食材数组
 @return 菜单
 */
+(RecipesModel *)recommendRecips:(NSArray <RecipesModel *>*)recips WithFoods:(NSArray <FoodModel *>*)foods{
    RecipesModel *recipe = nil;
    //计算所有菜单对应已选食物的推荐模型
    NSArray *allRecipesRecommendModels = [self calculationllRecipes:recips WithFoods:foods];
    //找到最佳菜谱
    recipe = [self bestRecipInRecommendModes:allRecipesRecommendModels];
    return recipe;
}
/**
 计算所有菜单对应已选食物的推荐模型

 @param foods 选择的食物
 @return 推荐模型数组
 */
+(NSArray *)calculationllRecipesWithFoods:(NSArray <FoodModel *>*)foods{
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
 计算所有菜单对应已选食物的推荐模型
 
 @param foods 选择的食物
 @return 推荐模型数组
 */
+(NSArray *)calculationllRecipes:(NSArray <RecipesModel *> *)recipes WithFoods:(NSArray <FoodModel *>*)foods{
    NSMutableArray *allRecommends = [[NSMutableArray alloc]init];
    for (RecipesModel *recipe in recipes) {
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
 包含给出食材的菜单们

 @param foods 食材们
 @return 菜单们
 */
+(NSArray *)recipesCotainFoods:(NSArray <FoodModel *>*)foods{
    
    //先找到包含这些食材的菜谱
    NSMutableArray *recipes = [[NSMutableArray alloc]init];
    
    NSMutableArray *foodNames = [[NSMutableArray alloc]init];
    for (FoodModel *afood in foods) {
        [foodNames addObject:afood.name];
    }
    for (RecipesModel *recip in [RecipesManager defaultManager].allRecipes) {//遍历菜谱
        //看一下菜谱需要的食材
        [recip.ingredients enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([foodNames containsObject:obj]) {//这个菜谱包含一选择食材
                NSLog(@"%@ 包含 %@",recip.name,obj);
                [recipes addObject:recip];
                *stop = YES;
            }
        }];
    }
    
    return recipes;
}


/**
 找到用冰箱里的食材可以做的菜谱

 @param recipes 菜谱们
 @return 想要的菜谱们
 */
+(NSArray <RecipesModel*>*)findCanMakeByRefifoodsWithRecipes:(NSArray <RecipesModel*>*)recipes{
    NSMutableArray *foodsNameInRefi = [[NSMutableArray alloc]init];
    for (FoodModel *foodInRef in [DataBaseManager defaultManager].foodsInRefigerator) {
        [foodsNameInRefi addObject:foodInRef.name];
    }
    
    NSMutableArray *resultRecipes = [[NSMutableArray alloc]init];
    [recipes enumerateObjectsUsingBlock:^(RecipesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL allCotain = YES;
        for (NSString *foodName in obj.ingredients) {
            if (![foodsNameInRefi containsObject:foodName]) {//冰箱里没这食材
                allCotain = NO;
                break;
            }
        }
        if (allCotain) {
            NSLog(@"%@ 可以用冰箱里的做",obj.name);
            [resultRecipes addObject:obj];
        }
    }];
    return resultRecipes;
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
    //所有放入冰箱的食材
    NSArray *allFoodsInfri = [DataBaseManager defaultManager].foodsInRefigerator;
    //冰箱里还能用的食材
    NSMutableArray *canUseFoods = [[NSMutableArray alloc]init];
    [allFoodsInfri enumerateObjectsUsingBlock:^(FoodModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.remainingDays>0) {
            [canUseFoods addObject:obj];
        }
    }];
    //包含还能用食材的菜品
    NSArray *cotainRes = [self recipesCotainFoods:canUseFoods];
    NSLog(@"cotain= %@",cotainRes);
    //现有食材可以做的菜品
    NSArray *canRes = [self findCanMakeByRefifoodsWithRecipes:cotainRes];
    NSLog(@"res= %@",canRes);
    recipe = [self recommendRecips:canRes WithFoods:canUseFoods];
    
    return recipe;
}
@end
