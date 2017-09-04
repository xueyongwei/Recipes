//
//  RefrigeratorTableViewController.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/26.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "FoodTableViewController.h"
#import "RefrigeratorTableViewCell.h"
#import "AddFoodViewController.h"

@interface FoodTableViewController ()
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation FoodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customTableView];
    self.dataSource = [[NSMutableArray alloc]init];
    [self refreshData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/**
 刷新数据
 */
-(void)refreshData{
    //清空一下数据
    [self.dataSource removeAllObjects];
    for (FoodModel *food in self.allFoods) {
        NSLog(@"species = %ld self.foodType= %ld",food.species,self.foodType);
        if (food.species == self.foodType) {//是当前的类型
            //添加到数据源
            [self.dataSource addObject:food];
        }
        //刷新界面显示
        [self.tableView reloadData];
    }
}
-(void)customTableView{
    [self.tableView registerNib:[UINib nibWithNibName:@"RefrigeratorTableViewCell" bundle:nil] forCellReuseIdentifier:@"RefrigeratorTableViewCell"];
    self.tableView.rowHeight = 60;
    self.tableView.allowsMultipleSelection = YES;
}

/**
 返回食材种类对应的中文名字

 @param type 类型
 @return 名字
 */
-(NSString *)foodStringOfType:(FoodType)type
{
    switch (type) {
        case FoodTypeFruits:
        {
            return @"水果";
        }
            break;
        case FoodTypeVegetables:
        {
            return @"蔬菜";
        }
            break;
        case FoodTypeMeat:
        {
            return @"肉食";
        }
            break;
        case FoodTypeFish:
        {
            return @"鱼虾";
        }
            break;
            
        default:
            return @"其他";
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RefrigeratorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefrigeratorTableViewCell" forIndexPath:indexPath];
    FoodModel *food = self.dataSource[indexPath.row];
    cell.food = food;
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoodModel *food = self.dataSource[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:kSelectedFoodNoti object:food];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoodModel *food = self.dataSource[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:kDeSelectedFoodNoti object:food];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
