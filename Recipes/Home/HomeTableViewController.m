//
//  HomeTableViewController.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/26.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "HomeTableViewController.h"
#import "OnkeyRecipesView.h"
#import "HomeTableViewCell.h"
@interface HomeTableViewController ()
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation HomeTableViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customTableView];
    [self prepareData];
}


/**
 定义列表
 */
-(void)customTableView
{
    OnkeyRecipesView *onekey = [[[NSBundle mainBundle]loadNibNamed:@"OnkeyRecipesView" owner:self options:nil]lastObject];
    CGFloat heightPer = 1169.0/1177.0;
    
    onekey.frame = CGRectMake(0, 0, YYScreenSize().width, YYScreenSize().width*heightPer);
    self.tableView.tableHeaderView = onekey;
    self.view.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 80;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
    
}

/**
 准备数据
 */
-(void)prepareData{
    NSArray *allFoods = [[DataBaseManager defaultManager] quryAllFoodsInRefigerator];
    
    [allFoods enumerateObjectsUsingBlock:^(FoodModel * aFood, NSUInteger idx, BOOL * _Nonnull stop) {
        if (aFood.remainingDays<3) {//即将过期
            [self.dataSource addObject:aFood];
        }
    }];
    [self.tableView reloadData];
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
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell" forIndexPath:indexPath];
    
    FoodModel *food = self.dataSource[indexPath.row];
    cell.iconImgView.image = [UIImage imageNamed:food.name];
    cell.nameLabel.text = food.name;
    cell.dayLabel.text = [NSString stringWithFormat:@"%ld天",food.remainingDays];
    cell.countLabel.text = [NSString stringWithFormat:@"%.1f%@",food.amount,food.unit];
    return cell;
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
