//
//  HealthIntakeHelper.m
//  Recipes
//
//  Created by 薛永伟 on 2017/9/2.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "HealthIntakeHelper.h"

@implementation HealthIntakeHelper
/**
 记录一次某个食谱的进餐
 
 @param recipe 食谱
 */
+(void)recoderHaveAmealWithRecipe:(RecipesModel *)recipe{
    
    for (NSString *IngredientName in recipe.ingredients) {
        NSLog(@"%@",IngredientName);
    }
    //根据食材的名字找到食材的模型实例数组
    NSArray *foods = [self foodModelWithIngrdientNames:recipe.ingredients];
    NSInteger energy = 0;
    for (FoodModel *food in foods) {
        energy += food.calorie;
    }
    //获取今日已摄入的能量值
    NSInteger localDataToday = [self energyIntakeToday];
    //加起来
    energy += localDataToday;
    //更新今日摄入能量数据
    [self updateEneryDateToLocal:energy];
}


/**
 根据食材的名字找到食材的模型实例

 @param names 食材名数组
 @return 食材模型实例数组
 */
+(NSArray *)foodModelWithIngrdientNames:(NSArray *)names{
    //找到所有的食材
    NSArray *allFoods = [[DataBaseManager defaultManager]quryAllFoods];
    //存储复合条件的食材
    NSMutableArray *foods = [[NSMutableArray alloc]init];
    
    for (FoodModel *food in allFoods) {
        //该食物在需求食材列表，抓起来
        if ([names containsObject:food.name]) {
            [foods addObject:food];
        }
    }
    return foods;
}
/**
 今天摄入的能量
 
 @return 能量值
 */
+(CGFloat)energyIntakeToday{
    //获取本地存储的饮食数据
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSDictionary *healthyData = [usf objectForKey:@"healthyData"];
    NSDate *date = [healthyData objectForKey:@"date"];
    if ([self istodyOfdate:date]) {//是今天的数据
        return [healthyData floatValueForKey:@"data" default:0];
    }
    return 0;
}


/**
 更新饮食数据到本地
 */
+(void)updateEneryDateToLocal:(CGFloat) energy{
    //获取本地存储的饮食数据
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSDictionary *healthyData = [usf objectForKey:@"healthyData"];
    NSDate *date = [healthyData objectForKey:@"date"];
    if (!date || ![self istodyOfdate:date]) {//不是今天的数据,或者还没有数据
        [usf setObject:[NSDate date] forKey:@"date"];
    }
    //更新饮食数据
    [usf setFloat:energy forKey:@"data"];
    //同步数据
    [usf synchronize];
}
/**
 判断是否是今天

 @param date 日期
 @return 是或否
 */
+(BOOL)istodyOfdate:(NSDate *)date
{
    if (fabs(date.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    NSInteger today = [self dayNumberOfDate:[NSDate date]];
    NSInteger dateDay = [self dayNumberOfDate:date];
    return today==dateDay;
}

/**
 一个日期的“日”

 @param date 日期
 @return 日
 */
+ (NSInteger)dayNumberOfDate:(NSDate *)date {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:date] day];
}

@end
