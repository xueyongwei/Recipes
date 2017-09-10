//
//  RecipesTableViewController.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/26.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "RecipesTableViewController.h"
#import "RecipesManager.h"
#import "RecipTableViewCell.h"
#import "RecipesDetailViewController.h"

@interface RecipesTableViewController ()

@end

@implementation RecipesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customTableView];
    if (self.dataSource==nil) {
        self.dataSource =[RecipesManager defaultManager].allRecipes;
    }else{
        [self custonNavi];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
/**
 自定义导航
 */
-(void)custonNavi{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"naviBack"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.tintColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(backHandle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itm = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fix.width = -10;
    self.navigationItem.leftBarButtonItems = @[fix,itm];
}

/**
 返回到上一层
 */
-(void)backHandle{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 定义列表
 */
-(void)customTableView{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecipTableViewCell"];
    self.tableView.rowHeight = 100;
    self.view.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    RecipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipTableViewCell" forIndexPath:indexPath];
    RecipesModel *model = self.dataSource[indexPath.row];
    cell.titleLabel.text = model.name;
    cell.iconImgView.image = [UIImage imageNamed:model.name];
    cell.bgImgView.image = [UIImage imageNamed:model.name];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipesModel *model = self.dataSource[indexPath.row];
    RecipesDetailViewController *detailVC = [[RecipesDetailViewController alloc]initWithNibName:@"RecipesDetailViewController" bundle:nil];
    detailVC.recipe = model;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
