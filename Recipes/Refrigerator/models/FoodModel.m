//
//  FoodModel.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/28.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "FoodModel.h"

@implementation FoodModel
+(instancetype)FoodWithFoodid:(NSInteger)foodid Name:(NSString *)name species:(NSInteger)species maxDay:(NSInteger)maxDay calorie:(NSInteger)calorie carbohydrate:(CGFloat)carbohydrate vitamin:(CGFloat)vitamin protein:(CGFloat)protein inRefigerator:(BOOL)inRefigerator putRefDate:(NSDate *)putRefDate amount:(CGFloat)amount unit:(NSString *)unit{
    FoodModel *food = [[FoodModel alloc]init];
    food.foodid = foodid;
    food.name = name;
    food.species = species;
    food.maxDay = maxDay;
    food.calorie = calorie;
    food.carbohydrate = carbohydrate;
    food.vitamin = vitamin;
    food.protein = protein;
    food.inRefigerator = inRefigerator;
    food.putRefDate = putRefDate;
    food.unit = unit;
    food.amount = amount;
    return food;
}
/**
 重写des方法
 
 @return des
 */
-(NSString *)description
{
    return [NSString stringWithFormat:@"name = %@, species = %ld ,inRefigerator= %d",self.name,(long)self.species,self.inRefigerator];
}
-(void)putIntoRefiAndUpdateDataBase
{
    [[DataBaseManager defaultManager] AddToRefiFoodModel:self];
}

/**
 食材声音日期
 
 @return 剩余的天数
 */
-(NSInteger)remainingDays{
    //过期的日期
    NSDate *expedDate = [self.putRefDate dateByAddingDays:self.maxDay];
    //现在的日期
    NSDate *nowDate = [NSDate date];
    //计算剩余的时间
    NSTimeInterval exp = [expedDate timeIntervalSince1970];
    NSTimeInterval now = [nowDate timeIntervalSince1970];
    NSInteger time = (exp-now)/86400;
    
    return time;
}



@end
