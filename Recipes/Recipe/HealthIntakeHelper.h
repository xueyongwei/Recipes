//
//  HealthIntakeHelper.h
//  Recipes
//
//  Created by 薛永伟 on 2017/9/2.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipersRecomendHelper.h"
@interface HealthIntakeHelper : NSObject

/**
 记录一次某个食谱的进餐

 @param recipe 食谱
 */
+(void)recoderHaveAmealWithRecipe:(RecipesModel *)recipe;


/**
 今天摄入的能量

 @return 能量值
 */
+(CGFloat)energyIntakeToday;

@end
