//
//  FoodModel.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/28.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "FoodModel.h"

@implementation FoodModel
+(instancetype)FoodWithName:(NSString *)name species:(NSInteger)species maxDay:(NSInteger)maxDay calorie:(NSInteger)calorie carbohydrate:(CGFloat)carbohydrate vitamin:(CGFloat)vitamin protein:(CGFloat)protein inRefigerator:(BOOL)inRefigerator putRefDate:(NSDate *)putRefDate{
    FoodModel *food = [[FoodModel alloc]init];
    food.name = name;
    food.species = species;
    food.maxDay = maxDay;
    food.calorie = calorie;
    food.carbohydrate = carbohydrate;
    food.vitamin = vitamin;
    food.protein = protein;
    food.inRefigerator = inRefigerator;
    food.putRefDate = putRefDate;
    return food;
}
@end
