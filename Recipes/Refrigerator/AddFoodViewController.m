//
//  AddFoodViewController.m
//  Recipes
//
//  Created by 薛永伟 on 2017/8/28.
//  Copyright © 2017年 XYW. All rights reserved.
//

#import "AddFoodViewController.h"
#import "DataBaseManager.h"
@interface AddFoodViewController () <UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
// 数据源数组
@property (nonatomic, strong) NSMutableArray *datas;
// 搜索结果数组
@property (nonatomic, strong) NSMutableArray *results;

@end

@implementation AddFoodViewController
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _datas;
}

- (NSMutableArray *)results {
    if (_results == nil) {
        _results = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _results;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建UISearchController, 这里使用当前控制器来展示结果
    UISearchController *search = [[UISearchController alloc]initWithSearchResultsController:nil];
    // 设置结果更新代理
    search.searchResultsUpdater = self;
    // 因为在当前控制器展示结果, 所以不需要这个透明视图
    search.dimsBackgroundDuringPresentation = NO;
    self.searchController = search;
    // 将searchBar赋值给tableView的tableHeaderView
    self.tableView.tableHeaderView = search.searchBar;
   
    [self prepareData];
    // Do any additional setup after loading the view from its nib.
}
-(void)prepareData{
    NSArray *data =  [[DataBaseManager defaultManager] quryAllFoods];
    NSLog(@"%@",data);
    self.datas = [NSMutableArray arrayWithArray:data];
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active) {
        
        return self.results.count ;
    }
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active ) {
        FoodModel *food = [self.results objectAtIndex:indexPath.row];
        cell.textLabel.text = food.name;
    } else {
        FoodModel *food = [self.datas objectAtIndex:indexPath.row];
        cell.textLabel.text = food.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchController.active) {
        NSLog(@"选择了搜索结果中的%@", [self.results objectAtIndex:indexPath.row]);
    } else {
        
        NSLog(@"选择了列表中的%@", [self.datas objectAtIndex:indexPath.row]);
    }
    
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //输入的文字
    NSString *inputStr = searchController.searchBar.text ;
    if (self.results.count > 0) {
        [self.results removeAllObjects];
    }
    //把包含输入文字的食物放到搜索结果数组里
    for (FoodModel *food in self.datas) {
        if ([food.name.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
            [self.results addObject:food];
        }
    }
    
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
