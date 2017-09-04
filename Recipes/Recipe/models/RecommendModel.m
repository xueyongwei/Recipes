//
//  RecommendModel.m
//  Recipes
//
//  Created by 薛永伟 on 2017/9/2.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "RecommendModel.h"
#import "RecipesModel.h"
@interface RecommendModel ()
//@property (nonatomic,strong) RecipesModel *recipe;
@property (nonatomic,strong) NSArray <FoodModel *> *foods;

@property (nonatomic,assign) NSInteger cotainFoodCount;//包含的食材的种类数
@property (nonatomic,assign) NSInteger expireDay;//可使用剩余天数
@property (nonatomic,assign) NSInteger nutritional;//所含营养
@end
@implementation RecommendModel

/**
 类方法，生成某一个菜单的推荐模型

 @param recipe 菜单
 @param foods 选择的食物
 @return 推荐模型
 */
+(RecommendModel *)recommendModelWithRecipe:(RecipesModel *)recipe andFoods:(NSArray *)foods{
    RecommendModel *recommend = [[RecommendModel alloc]init];
    recommend.recipe = recipe;
    recommend.foods = foods;
    recommend.cotainFoodCount = 0;
    recommend.expireDay = 1;
    recommend.nutritional = 1;
    return recommend;
}


/**
 计算此菜单推荐指数
 */
-(void)calculationPriority
{
    for (FoodModel *food in self.foods) {
        //计算食物覆盖度
        if ([self.recipe.ingredients containsObject:food.name]) {
            NSLog(@"ingredients %@, name%@",self.recipe.ingredients ,food.name);
            self.cotainFoodCount +=1;
        }
        //计算保质期对应的推荐指数
        //有一个食材是过期的，都不能选
        self.expireDay *= [self priorotyOfExpdayWithFood:food];
        //计算营养对应的推荐指数
        self.nutritional += [self nutritionalPriorotyOfColorie:food.calorie];
        self.nutritional += [self nutritionalPriorotyOfCarbohydrate:food.carbohydrate];
        self.nutritional += [self nutritionalPriorotyOfVitamin:food.vitamin];
        self.nutritional += [self nutritionalPriorotyOfProtein:food.protein];
    }
    NSLog(@"cotain %ld exprireDay %ld nutritional %ld",(long)self.cotainFoodCount,(long)self.expireDay,(long)self.nutritional);
    //计算推荐指数（任何一个指数为0，均可导致推荐指数为0）
    self.priority = self.cotainFoodCount*self.expireDay*self.nutritional;
}


/**
 计算保质期时间的推荐指数

 @param food 食材
 @return 推荐指数
 */
-(CGFloat)priorotyOfExpdayWithFood:(FoodModel *)food {
    //计算保质期
    CGFloat priorty = 1;//初始推荐指数
    //过期的日期
    NSDate *expedDate = [food.putRefDate dateByAddingDays:food.maxDay];
    //现在的日期
    NSDate *nowDate = [NSDate date];
    //计算剩余的时间
    NSTimeInterval exp = [expedDate timeIntervalSince1970];
    NSTimeInterval now = [nowDate timeIntervalSince1970];
    NSInteger time = exp-now;
    
    if (time<0) {//过期了
        //相对健康，宁可换一种食材，也不选用过期的食材
        return  0;//过期了不能选用。
    }else{
         NSInteger expDay =  time/86400;
        if (expDay<3) {//剩余日期不足3天，大幅提高推荐指数
            //让剩余的天数对应的指数大，比如1天对应的是99，2天对用的是98，99*99=9801>98*98=9604,时间越短指数越高
            NSInteger prp = 100-expDay;
            priorty = prp*prp;//指数级别提升
        }else{//时间还早
            priorty = 100-expDay;
        }
    }
    return priorty;
}
/**
 获取卡路里对应的营养指数

 @param calorie 卡路里
 @return 营养指数
 */
-(CGFloat)nutritionalPriorotyOfColorie:(CGFloat)calorie{
    //食物的卡路里不能低于10
    return calorie+10;
}
/**
 获取碳水化合物对应的营养指数
 
 @param carbohydrate 碳水化合物
 @return 营养指数
 */
-(CGFloat)nutritionalPriorotyOfCarbohydrate:(CGFloat)carbohydrate{
    //降低碳水化合物的推荐指数
    return carbohydrate*0.8;
}
/**
 获取维他命对应的营养指数
 
 @param vitamin 维他命
 @return 营养指数
 */
-(CGFloat)nutritionalPriorotyOfVitamin:(CGFloat)vitamin{
    return vitamin*3;
}

/**
 获取蛋白质对应的营养指数
 
 @param protein 蛋白质
 @return 营养指数
 */
-(CGFloat)nutritionalPriorotyOfProtein:(CGFloat)protein{
    return protein*2;
}

@end
