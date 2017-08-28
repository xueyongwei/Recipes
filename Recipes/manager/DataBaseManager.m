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
            BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_food (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL,species integer NOT NULL, maxDay integer NOT NULL,calorie integer NOT NULL,carbohydrate DOUBLE NOT NULL,vitamin DOUBLE NOT NULL,protein DOUBLE NOT NULL,inRefigerator BOOLEAN ,putRefDate DATE);"];
            if (result)
            {
                NSLog(@"创建食物表成功");
                [wkSelf createDateIfNothingIndb:db];
            }else
            {
                NSLog(@"创建食物表失败");
            }
        }

    }];
}


/**
 创建初始数据，如果表里什么还没有
 */
-(void)createDateIfNothingIndb:(FMDatabase *)db{
        NSArray *foods = [self customFoodsModel];
    FMResultSet *resultSet = [db executeQuery:@"select * from t_food;"];
    if (!resultSet.next) {
        for (FoodModel *food in foods) {
            BOOL isSuccess =[db executeUpdate:@"INSERT INTO t_food (name,species,maxDay,calorie,carbohydrate,vitamin,protein,inRefigerator,putRefDate) VALUES (?,?,?,?,?,?,?,?,?);" withArgumentsInArray:@[food.name ,@(food.species),@(food.maxDay),@(food.calorie),@(food.carbohydrate),@(food.vitamin),@(food.protein),@(food.inRefigerator),food.putRefDate]];
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
    
    FoodModel *cucumber = [FoodModel FoodWithName:@"黄瓜" species:1 maxDay:7 calorie:15 carbohydrate:2 vitamin:9 protein:1 inRefigerator:NO putRefDate:[NSDate date]];
    [foods addObject:cucumber];
    
    FoodModel *tomato = [FoodModel FoodWithName:@"番茄" species:1 maxDay:5 calorie:19 carbohydrate:4 vitamin:19 protein:1 inRefigerator:NO putRefDate:[NSDate date]];
    [foods addObject:tomato];
    
    FoodModel *eggplant = [FoodModel FoodWithName:@"茄子" species:1 maxDay:6 calorie:21 carbohydrate:3.6 vitamin:5 protein:1.1 inRefigerator:NO putRefDate:[NSDate date]];
    [foods addObject:eggplant];
    
    FoodModel *potato = [FoodModel FoodWithName:@"" species:1 maxDay:10 calorie:76 carbohydrate:16.5 vitamin:27 protein:2 inRefigerator:NO putRefDate:[NSDate date]];
    [foods addObject:potato];
    
    FoodModel *beef = [FoodModel FoodWithName:@"牛肉" species:2 maxDay:7 calorie:155 carbohydrate:1 vitamin:0 protein:20 inRefigerator:NO putRefDate:[NSDate date]];
    [foods addObject:beef];
    
    FoodModel *pork = [FoodModel FoodWithName:@"猪肉" species:2 maxDay:7 calorie:106 carbohydrate:1 vitamin:0 protein:20 inRefigerator:NO putRefDate:[NSDate date]];
    [foods addObject:pork];
    
    FoodModel *salmon = [FoodModel FoodWithName:@"三文鱼" species:3 maxDay:4 calorie:139 carbohydrate:2.9 vitamin:0 protein:17.2 inRefigerator:NO putRefDate:[NSDate date]];
    [foods addObject:salmon];
    
    FoodModel *prawns = [FoodModel FoodWithName:@"明虾" species:3 maxDay:4 calorie:85 carbohydrate:3.8 vitamin:0 protein:13.4 inRefigerator:NO putRefDate:[NSDate date]];
    [foods addObject:prawns];
    
    FoodModel *egg = [FoodModel FoodWithName:@"鸡蛋" species:3 maxDay:10 calorie:144 carbohydrate:2.8 vitamin:0 protein:13.3 inRefigerator:NO putRefDate:[NSDate date]];
    [foods addObject:egg];
    
    FoodModel *apple = [FoodModel FoodWithName:@"苹果" species:4 maxDay:8 calorie:52 carbohydrate:12.3 vitamin:4 protein:0.2 inRefigerator:NO putRefDate:[NSDate date]];
    [foods addObject:apple];
    /*
     需要添加新的数据，仿照下面的添加即可。
     */
    FoodModel *pineapple = [FoodModel FoodWithName:@"菠萝" species:4 maxDay:7 calorie:41 carbohydrate:9.5 vitamin:18 protein:0.5 inRefigerator:NO putRefDate:[NSDate date]];
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
            BOOL isSuccess = [db executeUpdate:@"INSERT INTO t_food (name,species,maxDay,calorie,carbohydrate,vitamin,protein,inRefigerator,putRefDate) VALUES (%@,%ld,%ld,%ld,%.2f,%.2f,%.2f,%d,%@);", food.name ,food.species,food.maxDay,food.calorie,food.carbohydrate,food.vitamin,food.protein,food.inRefigerator,food.putRefDate];
            NSLog(@"%@", isSuccess ? @"插入食材数据成功" : @"插入食材数据失败");
        }
    }];
}
@end
