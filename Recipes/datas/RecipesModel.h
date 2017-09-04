//
//  RecipesModel.h
//  Recipes
//
//  Created by xueyognwei on 2017/8/31.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipesModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *seasoning;
@property (nonatomic,strong) NSArray *ingredients;
@property (nonatomic,strong) NSArray *steps;


@end
