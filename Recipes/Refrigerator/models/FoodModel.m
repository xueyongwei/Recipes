//
//  FoodModel.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/28.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "FoodModel.h"

@implementation FoodModel
+(instancetype)FoodWithFoodid:(NSInteger)foodid Name:(NSString *)name species:(NSInteger)species maxDay:(NSInteger)maxDay calorie:(NSInteger)calorie carbohydrate:(CGFloat)carbohydrate vitamin:(CGFloat)vitamin protein:(CGFloat)protein inRefigerator:(BOOL)inRefigerator putRefDate:(NSDate *)putRefDate unit:(NSString *)unit{
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
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET amount = %f, putRefDate = %f , inRefigerator = 1 WHERE foodid = %ld;",kFoodTableName,self.amount,[self.putRefDate timeIntervalSince1970],self.foodid];
    [[DataBaseManager defaultManager].dbQueue inDatabase:^(FMDatabase *db) {
        BOOL isSuccess = [db executeUpdate:sql];
        NSLog(@"%@", isSuccess ? @"插入食材数据成功" : @"插入食材数据失败");
    }];
}
@end
