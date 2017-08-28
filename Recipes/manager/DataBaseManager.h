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


@interface DataBaseManager : NSObject
@property (nonatomic,strong) FMDatabaseQueue *dbQueue;

+(instancetype)defaultManager;
-(void)setUp;

@end
