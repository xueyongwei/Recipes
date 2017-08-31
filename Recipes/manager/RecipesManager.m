//
//  RecipesManager.m
//  Recipes
//
//  Created by xueyognwei on 2017/8/31.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "RecipesManager.h"

@implementation RecipesManager
/**
 单例，菜谱管理器
 
 @return 单例
 */
+(instancetype)defaultManager{
    static RecipesManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RecipesManager alloc]init];
        manager.allRecipes = [[NSMutableArray alloc]init];
    });
    return manager;
}

/**
 初始化
 */
-(void)setUp{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MenuDetail" ofType:@"plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
        if (array.count>0) {
            for (NSDictionary *dic in array) {
                RecipesModel *recipe = [RecipesModel modelWithDictionary:dic];
                [self.allRecipes addObject:recipe];
            }
        }else{
            NSLog(@"菜单为空！");
        }
        
    }
}
@end
