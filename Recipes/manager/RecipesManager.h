//
//  RecipesManager.h
//  Recipes
//
//  Created by xueyognwei on 2017/8/31.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipesModel.h"
@interface RecipesManager : NSObject

/**
 所有的菜谱
 */
@property (nonatomic,strong) NSMutableArray <RecipesModel *> *allRecipes;

/**
 单例，菜谱管理器
 
 @return 单例
 */
+(instancetype)defaultManager;

/**
 初始化
 */
-(void)setUp;
@end
