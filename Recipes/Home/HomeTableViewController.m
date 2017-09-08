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
#import "LoginViewController.h"
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
    //只有这一次去查询数据库，然后缓存到内存，以后直接从[DataBaseManager defaultManager].allFoods取
    
    [self customTableView];
    [self prepareData];
    //弹出登录窗口
    [self presentLogin];
    //监听食材的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDeleteFoodNoti:) name:kFoodTableChangedNoti object:nil];
}

-(void)receiveDeleteFoodNoti:(NSNotification *)noti{
    FoodModel *food = noti.object;
    [self.dataSource enumerateObjectsUsingBlock:^(FoodModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (food.foodid == obj.foodid ) {
            *stop = YES;
            [self.dataSource removeObject:obj];
            [self.tableView reloadData];
        }
    }];
}

/**
 模拟用户登录状态
 */
-(void)presentLogin{
    LoginViewController *lvc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self presentViewController:lvc animated:NO completion:nil];
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
    
    [self.dataSource removeAllObjects];
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
    [cell setModel:food AtIndexPath:indexPath];
    
    cell.iconImgView.image = [UIImage imageNamed:food.name];
    cell.nameLabel.text = food.name;
    cell.dayLabel.text = food.remainingDays>0?[NSString stringWithFormat:@"%ld天",food.remainingDays]:@"已过期";
    cell.countLabel.text = [NSString stringWithFormat:@"%.1f%@",food.amount,food.unit];
    __weak typeof(self) wkSelf = self;
    cell.clickDeleteBtn = ^(FoodModel *food) {
        [wkSelf deleteFoodModel:food];
    };
    return cell;
}

//删除某个食材
-(void)deleteFoodModel:(FoodModel *)food{
    NSInteger row = [self.dataSource indexOfObject:food];
    [self.dataSource removeObjectAtIndex:row];
    [self.tableView deleteRow:row inSection:0 withRowAnimation:UITableViewRowAnimationLeft];
    [[DataBaseManager defaultManager] removeFoodModel:food];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoodModel *food = self.dataSource[indexPath.row];
    if (food.remainingDays<1) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"该食材已过期！" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil ];
        [alv show];
    }
    //    [self.tabBarController setSelectedIndex:2];
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat contentOffsetY = scrollView.contentOffset.y;
//    NSLog(@"%f",contentOffsetY);
//    if (contentOffsetY>50) {
//
//        [self.tabBarController setSelectedIndex:2];
//    }
//}
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    CGFloat height = scrollView.frame.size.height;
//    CGFloat contentOffsetY = scrollView.contentOffset.y;
//
//    CGFloat a = contentOffsetY+height;
//    NSLog(@"%f",contentOffsetY);
//    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
//
//    if (height-bottomOffset>50)
//    {
//        //在最底部
////        [self.tabBarController setSelectedIndex:2];
//    }
//    else
//    {
//
//    }
//
//}
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
