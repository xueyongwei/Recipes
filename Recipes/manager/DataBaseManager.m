//
//  DataBaseManager.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/28.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "DataBaseManager.h"

@implementation DataBaseManager
+(instancetype)defaultManager{
    static DataBaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataBaseManager alloc]init];
        
    });
    return manager;
}
-(void)setUp{
    [self initDataBase];
}
-(void)initDataBase{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"foods.sqlite"];
    NSLog(@"数据库存储地址:%@",fileName);
    
    //2.获得数据库
    __weak typeof(self) wkSelf = self;
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open])
        {
            //4.创表
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT,foodid integer NOT NULL, name text NOT NULL,species integer NOT NULL, maxDay integer NOT NULL,calorie integer NOT NULL,carbohydrate REAL NOT NULL,vitamin REAL NOT NULL,protein REAL NOT NULL,inRefigerator BOOLEAN ,putRefDate INTEGER,amount REAL,unit text);",kFoodTableName];
            BOOL foodTableResult = [db executeUpdate:sql];
            if (foodTableResult){
                NSLog(@"创建食材库表成功");
                [wkSelf createDateIfNothingIndb:db];
            }else{
                NSLog(@"创建食材库失败");
            }
        }
    }];
}


/**
 创建初始数据，如果表里什么还没有
 */
-(void)createDateIfNothingIndb:(FMDatabase *)db{
    NSArray *foods = [self customFoodsModel];
    NSString *querySql = [NSString stringWithFormat:@"select * from %@;",kFoodTableName];
    FMResultSet *resultSet = [db executeQuery:querySql];
    if (!resultSet.next) {
        for (FoodModel *food in foods) {
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (foodid,name,species,maxDay,calorie,carbohydrate,vitamin,protein,inRefigerator,unit) VALUES (%ld,'%@',%ld,%ld,%ld,%.2f,%.2f,%.2f,%d,'%@')",kFoodTableName,food.foodid,food.name ,food.species,food.maxDay,food.calorie,food.carbohydrate,food.vitamin,food.protein,food.inRefigerator,food.unit];
            BOOL isSuccess =[db executeUpdate:sql];
            NSLog(@"%@", isSuccess ? @"插入食材数据成功" : @"插入食材数据失败");
        }
    }else{
        NSLog(@"已有数据");
    }
    [resultSet close];
   
}

/**
 初始化一些食材数据

 @return 食材数据数组
 */
-(NSArray *)customFoodsModel{
    NSMutableArray *foods = [[NSMutableArray alloc]init];
    
    FoodModel *cucumber = [FoodModel FoodWithFoodid:10000 Name:@"黄瓜" species:1 maxDay:7 calorie:15 carbohydrate:2 vitamin:9 protein:1 inRefigerator:NO putRefDate:[NSDate date] unit:@"根"];
    [foods addObject:cucumber];
    
    FoodModel *tomato = [FoodModel FoodWithFoodid:10001 Name:@"番茄" species:1 maxDay:5 calorie:19 carbohydrate:4 vitamin:19 protein:1 inRefigerator:NO putRefDate:[NSDate date] unit:@"个"];
    [foods addObject:tomato];
    
    FoodModel *eggplant = [FoodModel FoodWithFoodid:10002 Name:@"茄子" species:1 maxDay:6 calorie:21 carbohydrate:3.6 vitamin:5 protein:1.1 inRefigerator:NO putRefDate:[NSDate date] unit:@"根"];
    [foods addObject:eggplant];
    
    FoodModel *potato = [FoodModel FoodWithFoodid:10003 Name:@"土豆" species:1 maxDay:10 calorie:76 carbohydrate:16.5 vitamin:27 protein:2 inRefigerator:NO putRefDate:[NSDate date] unit:@"个"];
    [foods addObject:potato];
    
    FoodModel *beef = [FoodModel FoodWithFoodid:10004 Name:@"牛肉" species:2 maxDay:7 calorie:155 carbohydrate:1 vitamin:0 protein:20 inRefigerator:NO putRefDate:[NSDate date] unit:@"克"];
    [foods addObject:beef];
    
    FoodModel *pork = [FoodModel FoodWithFoodid:10005 Name:@"猪肉" species:2 maxDay:7 calorie:106 carbohydrate:1 vitamin:0 protein:20 inRefigerator:NO putRefDate:[NSDate date] unit:@"克"];
    [foods addObject:pork];
    
    FoodModel *salmon = [FoodModel FoodWithFoodid:10006 Name:@"三文鱼" species:3 maxDay:4 calorie:139 carbohydrate:2.9 vitamin:0 protein:17.2 inRefigerator:NO putRefDate:[NSDate date] unit:@"克"];
    [foods addObject:salmon];
    
    FoodModel *prawns = [FoodModel FoodWithFoodid:10007 Name:@"明虾" species:3 maxDay:4 calorie:85 carbohydrate:3.8 vitamin:0 protein:13.4 inRefigerator:NO putRefDate:[NSDate date] unit:@"只"];
    [foods addObject:prawns];
    
    FoodModel *egg = [FoodModel FoodWithFoodid:10008 Name:@"鸡蛋" species:3 maxDay:10 calorie:144 carbohydrate:2.8 vitamin:0 protein:13.3 inRefigerator:NO putRefDate:[NSDate date] unit:@"个"];
    [foods addObject:egg];
    
    FoodModel *apple = [FoodModel FoodWithFoodid:10009 Name:@"苹果" species:4 maxDay:8 calorie:52 carbohydrate:12.3 vitamin:4 protein:0.2 inRefigerator:NO putRefDate:[NSDate date] unit:@"个"];
    [foods addObject:apple];
    /*
     需要添加新的数据，仿照下面的添加即可。
     */
    FoodModel *pineapple = [FoodModel FoodWithFoodid:10010 Name:@"菠萝" species:4 maxDay:7 calorie:41 carbohydrate:9.5 vitamin:18 protein:0.5 inRefigerator:NO putRefDate:[NSDate date] unit:@"个"];
    [foods addObject:pineapple];
    
    
    return foods;
    
}

/**
 使用事务批量添加初始化食材数据

 @param foods 食材数组
 */
- (void)insertFoodsUseTransaction:(NSArray<FoodModel *>*)foods {
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        for (FoodModel *food in foods) {
            BOOL isSuccess = [db executeUpdate:@"INSERT INTO t_foods (name,species,maxDay,calorie,carbohydrate,vitamin,protein,inRefigerator,putRefDate) VALUES (%@,%ld,%ld,%ld,%.2f,%.2f,%.2f,%d,%@);", food.name ,food.species,food.maxDay,food.calorie,food.carbohydrate,food.vitamin,food.protein,food.inRefigerator,food.putRefDate];
            NSLog(@"%@", isSuccess ? @"插入食材数据成功" : @"插入食材数据失败");
        }
    }];
}


/**
 查询食材库里的所有的食材

 @return 食材model数组
 */
-(NSArray *)quryAllFoods{
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ ;",kFoodTableName];
    NSArray *result = [self fmQuryWithSql:querySql];
    return result;
}

/**
 查询冰箱里的所有的食材
 
 @return 食材model数组
 */
-(NSArray *)quryAllFoodsInRefigerator{
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where inRefigerator;",kFoodTableName];
    NSArray *result = [self fmQuryWithSql:querySql];
    return result;
}


/**
 查询冰箱里即将过期的食材
 
 @return 食材model数组
 */
-(NSArray *)quryExpiringFoodsInRefigerator{
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where inRefigerator and ",kFoodTableName];
    NSArray *result = [self fmQuryWithSql:querySql];
    return result;
}
/**
 查询一条sql语句

 @param sqlStr sql语句
 @return 查询的model结果数组
 */
-(NSArray *)fmQuryWithSql:(NSString *)sqlStr{
    __block FoodModel *model = nil;
    __weak NSMutableArray *resultArray = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sqlStr];
        while ([result next])
        {
            NSString *name = [result stringForColumn:@"name"];
            NSInteger foodid = [result longForColumn:@"foodid"];
            NSInteger species = [result longForColumn:@"species"];
            NSInteger maxDay = [result longForColumn:@"maxDay"];
            NSInteger calorie = [result longForColumn:@"calorie"];
            
            CGFloat carbohydrate = [result doubleForColumn:@"carbohydrate"];
            CGFloat vitamin = [result doubleForColumn:@"vitamin"];
            CGFloat protein = [result doubleForColumn:@"protein"];
            BOOL inRefigerator = [result boolForColumn:@"inRefigerator"];
            NSDate *putRefDate = [result dateForColumn:@"putRefDate"];
            NSString *unit = [result stringForColumn:@"unit"];
            model = [FoodModel FoodWithFoodid:foodid Name:name species:species maxDay:maxDay calorie:calorie carbohydrate:carbohydrate vitamin:vitamin protein:protein inRefigerator:inRefigerator putRefDate:putRefDate unit:unit];
            [resultArray addObject:model];
        }
    }];
    return resultArray;
}
@end
