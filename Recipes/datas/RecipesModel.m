//
//  RecipesModel.m
//  Recipes
//
//  Created by xueyognwei on 2017/8/31.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "RecipesModel.h"

@implementation RecipesModel
-(FoodModel *)getfoodModelWithFoodName:(NSString *)foodName{
    NSArray *allFoods = [DataBaseManager defaultManager].allFoods;
    __block FoodModel *returnFood = nil;
    [allFoods enumerateObjectsUsingBlock:^(FoodModel *food, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([food.name isEqualToString:foodName]) {
            *stop = YES;
            returnFood = food;
        }
    }];
    return returnFood;
}

//-(NSString *)description
//{
//    return [NSString stringWithFormat:@"%s:%@",self.name.UTF8String,self.ingredients];
//}
@end
