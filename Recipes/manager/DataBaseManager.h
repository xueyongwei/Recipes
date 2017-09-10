//
//  DataBaseManager.h
//  Recipes
//
//  Created by 薛永伟 on 2017/8/28.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "FoodModel.h"

#define kFoodTableName @"t_foods"
#define kFoodTableChangedNoti @"FoodTableChangedNoti"

@interface DataBaseManager : NSObject
@property (nonatomic,strong) FMDatabaseQueue *dbQueue;
@property (nonatomic,strong) NSMutableArray *allFoods;
@property (nonatomic,strong) NSMutableArray *foodsInRefigerator;

/**
 单例，数据库管理器

 @return 单例
 */
+(instancetype)defaultManager;


/**
 初始化数据库
 */
-(void)setUp;

/**
 查询食材库里的所有的食材
 
 @return 食材model数组
 */
//-(NSArray *)quryAllFoods;
/**
 查询冰箱里的所有的食材
 
 @return 食材model数组
 */
//-(NSArray *)quryAllFoodsInRefigerator;

/**
 查询冰箱里即将过期的食材
 
 @return 食材model数组
 */
-(NSArray *)quryExpiringFoodsInRefigerator;


/**
 从冰箱移除某个食材

 @param food 食材
 */
-(void)removeFoodModel:(FoodModel *)food;

/**
 添加到冰箱某个食材
 
 @param food 食材
 */
-(void)AddToRefiFoodModel:(FoodModel *)food;
@end
