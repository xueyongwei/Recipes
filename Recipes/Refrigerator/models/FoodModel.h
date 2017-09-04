//
//  FoodModel.h
//  Recipes
//
//  Created by 薛永伟 on 2017/8/28.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,FoodType){
    FoodTypeVegetables=1,
    FoodTypeMeat,
    FoodTypeFish,
    FoodTypeFruits,
    FoodTypeOther,
};
@interface FoodModel : NSObject

/**
 食材ID
 */
@property (nonatomic,assign) NSInteger foodid;

/**
 食材名
 */
@property (nonatomic,copy) NSString *name;

/**
 食材种类
 */
@property (nonatomic,assign) NSInteger species;

/**
 有效期
 */
@property (nonatomic,assign) NSInteger maxDay;

/**
 卡路里
 */
@property (nonatomic,assign) NSInteger calorie;

/**
 碳水化合物
 */
@property (nonatomic,assign) CGFloat carbohydrate;

/**
 维他命
 */
@property (nonatomic,assign) CGFloat vitamin;

/**
 蛋白质
 */
@property (nonatomic,assign) CGFloat protein;

/**
 是否已放进冰箱
 */
@property (nonatomic,assign) BOOL inRefigerator;

/**
 放入冰箱日期
 */
@property (nonatomic,strong) NSDate *putRefDate;

/**
 数量
 */
@property (nonatomic,assign) CGFloat amount;

/**
 计量单位
 */
@property (nonatomic,copy) NSString *unit;


+(instancetype)FoodWithFoodid:(NSInteger)foodid Name:(NSString *)name species:(NSInteger)species maxDay:(NSInteger)maxDay calorie:(NSInteger)calorie carbohydrate:(CGFloat)carbohydrate vitamin:(CGFloat)vitamin protein:(CGFloat)protein inRefigerator:(BOOL)inRefigerator putRefDate:(NSDate *)putRefDate amount:(CGFloat)amount unit:(NSString *)unit;


/**
 将食材放入冰箱，并更新本地数据库
 */
-(void)putIntoRefiAndUpdateDataBase;


/**
 重写des方法

 @return des
 */
-(NSString *)description;


/**
 食材声音日期

 @return 剩余的天数
 */
-(NSInteger)remainingDays;

@end
